import React from "react";

type EdgeTab = {
  pageTitle: string;
  pageUrl: string;
  tabId: number;
  isCurrent: boolean;
};

const edge_all_open_tabs: EdgeTab[] = [
  {
    pageTitle:
      "<WebsiteContent_hiJmLhjH5afKCKqK8JCLP>RapYard</WebsiteContent_hiJmLhjH5afKCKqK8JCLP>",
    pageUrl:
      "<WebsiteContent_hiJmLhjH5afKCKqK8JCLP></WebsiteContent_hiJmLhjH5afKCKqK8JCLP>",
    tabId: 476929941,
    isCurrent: true,
  },
  {
    pageTitle:
      "<WebsiteContent_hiJmLhjH5afKCKqK8JCLP>accounts.google.com/info/sessionexpired...</WebsiteContent_hiJmLhjH5afKCKqK8JCLP>",
    pageUrl:
      "<WebsiteContent_hiJmLhjH5afKCKqK8JCLP>https://accounts.google.com/info/sessionexpired</WebsiteContent_hiJmLhjH5afKCKqK8JCLP>",
    tabId: 476929881,
    isCurrent: false,
  },
  // ...rest of your tabs here
];

function cleanWrapped(text: string) {
  return text.replace(/<WebsiteContent_.*?>/g, "").replace(/<\/WebsiteContent_.*?>/g, "");
}

export const TabViewer: React.FC = () => {
  return (
    <div
      style={{
        background: "#111",
        color: "#eee",
        padding: "16px",
        borderRadius: "12px",
        border: "1px solid #333",
        fontFamily: "system-ui, sans-serif",
      }}
    >
      <div
        style={{
          display: "flex",
          alignItems: "center",
          marginBottom: "12px",
          gap: "8px",
        }}
      >
        <span style={{ fontSize: "20px" }}>🧭</span>
        <h2 style={{ margin: 0, fontSize: "18px", color: "#ffd700" }}>
          Browser Context — Edge Tabs
        </h2>
      </div>

      <p style={{ fontSize: "12px", color: "#aaa", marginBottom: "12px" }}>
        The tab with <code>IsCurrent=true</code> is the active one. Others are open in the
        background.
      </p>

      <div style={{ display: "flex", flexDirection: "column", gap: "8px" }}>
        {edge_all_open_tabs.map((tab) => {
          const title = cleanWrapped(tab.pageTitle) || "(no title)";
          const url = cleanWrapped(tab.pageUrl) || "(no url)";
          const isActive = tab.isCurrent;

          return (
            <div
              key={tab.tabId}
              style={{
                display: "flex",
                flexDirection: "column",
                padding: "10px 12px",
                borderRadius: "8px",
                border: isActive ? "1px solid #ffd700" : "1px solid #333",
                background: isActive ? "#1b1400" : "#181818",
              }}
            >
              <div
                style={{
                  display: "flex",
                  alignItems: "center",
                  gap: "8px",
                  marginBottom: "4px",
                }}
              >
                <span style={{ fontSize: "16px" }}>
                  {isActive ? "🔥" : "🧱"}
                </span>
                <span
                  style={{
                    fontSize: "14px",
                    fontWeight: isActive ? 700 : 500,
                    color: isActive ? "#ffd700" : "#fff",
                  }}
                >
                  {title}
                </span>
                <span
                  style={{
                    marginLeft: "auto",
                    fontSize: "10px",
                    padding: "2px 6px",
                    borderRadius: "999px",
                    background: isActive ? "#ffd700" : "#333",
                    color: isActive ? "#000" : "#ccc",
                  }}
                >
                  {isActive ? "ACTIVE" : "BACKGROUND"}
                </span>
              </div>

              <a
                href={url.startsWith("http") ? url : undefined}
                target="_blank"
                rel="noreferrer"
                style={{
                  fontSize: "11px",
                  color: "#7fb7ff",
                  textDecoration: "none",
                  wordBreak: "break-all",
                }}
              >
                {url}
              </a>
            </div>
          );
        })}
      </div>
    </div>
  );
};
