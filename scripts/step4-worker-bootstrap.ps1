Write-Host "🔥 Bootstrapping Step 4 — Worker Queues + Cron..."

function Write-File($path, $content) {
    $dir = Split-Path $path
    if (!(Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
    Set-Content -Path $path -Value $content -Encoding UTF8
}

# Ensure worker structure exists
New-Item -ItemType Directory -Force -Path "apps/worker/src/jobs" | Out-Null

# Queue system
Write-File "apps/worker/src/queue.ts" @'
export const queue = {
  jobs: [],
  add(job) {
    this.jobs.push(job);
  },
  process() {
    while (this.jobs.length) {
      const job = this.jobs.shift();
      console.log("[worker] processing job:", job);
    }
  }
};
'@

# Cron heartbeat
Write-File "apps/worker/src/cron.ts" @'
export function startCron() {
  setInterval(() => {
    console.log("[cron] heartbeat:", new Date().toISOString());
  }, 60000);
}
'@

# Example job: waveform generation
Write-File "apps/worker/src/jobs/generate-waveform.ts" @'
export async function generateWaveform(trackId) {
  console.log("[job] generateWaveform for track:", trackId);
  return { ok: true };
}
'@

# Example job: feed ranking
Write-File "apps/worker/src/jobs/rank-feed.ts" @'
export async function rankFeed() {
  console.log("[job] rankFeed running...");
  return { ok: true };
}
'@

# Worker entrypoint
Write-File "apps/worker/src/index.ts" @'
import { queue } from "./queue";
import { startCron } from "./cron";
import { generateWaveform } from "./jobs/generate-waveform";
import { rankFeed } from "./jobs/rank-feed";

console.log("Worker started.");

startCron();

// Example: enqueue jobs every 5 seconds
setInterval(() => {
  queue.add({ type: "waveform", run: () => generateWaveform("track_123") });
  queue.add({ type: "rank", run: () => rankFeed() });

  queue.process();
}, 5000);
'@

Write-Host "✅ Step 4 complete — Worker queues + cron generated!"
