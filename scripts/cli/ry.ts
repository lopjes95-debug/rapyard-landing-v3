#!/usr/bin/env node

const args = process.argv.slice(2);
const cmd = args[0];
const param = args[1];

switch (cmd) {
  case "init":
    require("./ry-init");
    break;

  case "doctor":
    require("./ry-doctor");
    break;

  case "build":
    require("./ry-build");
    break;

  case "upgrade":
    require("./ry-upgrade");
    break;

  case "generate":
    require("./ry-generate-module")(param);
    break;

  case "scaffold":
    require("./ry-scaffold-api")(param);
    break;

  case "studio":
    require("./ry-studio");
    break;

  default:
    console.log(`
RAPYARD OS CLI

Commands:
  ry init                 Bootstrap full monorepo
  ry doctor               Health checks
  ry build                Production build
  ry upgrade              Migrate v6 → v12 → v20
  ry generate module <n>  Create new module/phase
  ry scaffold api <n>     Create API route + service + types
  ry studio               Local dev orchestrator
`);
}

