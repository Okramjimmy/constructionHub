
<style>
@import url('https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;600&family=Sora:wght@400;500;600;700&display=swap');
*{box-sizing:border-box;margin:0;padding:0}
:root{
--navy:#0A192F;--navy2:#0F2340;--navy3:#1a3a5c;
--orange:#FF6B00;--orange2:#e85f00;
--slate:#8B9DB5;--light:#F4F6F9;--white:#ffffff;
--green:#1a9e5c;--yellow:#d4a017;--red:#c0392b;
--text:#1a2b3c;--muted:#6b7c93;--border:#dce3ed;
}
body{font-family:'Sora',sans-serif;background:#e8ecf1}
.device{width:375px;height:780px;background:var(--white);border-radius:40px;overflow:hidden;border:8px solid #1a1a2e;box-shadow:0 20px 60px rgba(0,0,0,0.35),inset 0 0 0 1px rgba(255,255,255,0.05);position:relative;margin:0 auto}
.notch{width:120px;height:28px;background:#1a1a2e;border-radius:0 0 18px 18px;position:absolute;top:0;left:50%;transform:translateX(-50%);z-index:100;display:flex;align-items:center;justify-content:center;gap:6px}
.notch-cam{width:10px;height:10px;border-radius:50%;background:#2a2a3e}
.notch-face{width:6px;height:6px;border-radius:50%;background:#3a3a5e}
.screen{width:100%;height:100%;overflow:hidden;position:relative}
.page{position:absolute;inset:0;overflow-y:auto;overflow-x:hidden;transform:translateX(100%);transition:transform 0.35s cubic-bezier(0.4,0,0.2,1);background:var(--white)}
.page.active{transform:translateX(0)}
.page::-webkit-scrollbar{display:none}
.status-bar{height:44px;display:flex;align-items:flex-end;justify-content:space-between;padding:0 24px 8px;font-size:11px;font-weight:600;color:var(--white);font-family:'IBM Plex Mono',monospace}
.navbar{display:flex;align-items:center;gap:12px;padding:12px 20px 14px}
.nav-back{width:36px;height:36px;border-radius:50%;background:rgba(255,255,255,0.12);display:flex;align-items:center;justify-content:center;cursor:pointer;border:none;flex-shrink:0}
.nav-back svg{width:18px;height:18px;stroke:var(--white);fill:none;stroke-width:2.5;stroke-linecap:round}
.nav-title{font-size:15px;font-weight:600;color:var(--white);flex:1;letter-spacing:0.01em}
.nav-breadcrumb{font-size:11px;color:rgba(255,255,255,0.55);font-family:'IBM Plex Mono',monospace;margin-top:1px}

#p1{background:var(--white)}
.login-top{background:var(--navy);padding:52px 28px 40px}
.logo-mark{width:56px;height:56px;border-radius:16px;background:var(--orange);display:flex;align-items:center;justify-content:center;margin-bottom:16px}
.logo-mark svg{width:30px;height:30px;stroke:var(--white);fill:none;stroke-width:2;stroke-linecap:round}
.logo-name{font-size:24px;font-weight:700;color:var(--white);letter-spacing:-0.5px}
.logo-sub{font-size:12px;color:var(--slate);margin-top:2px;font-family:'IBM Plex Mono',monospace;letter-spacing:0.08em}
.login-body{padding:32px 28px 28px;background:var(--light);min-height:440px}
.login-card{background:var(--white);border-radius:20px;padding:28px 24px;border:1px solid var(--border)}
.field-wrap{margin-bottom:20px}
.field-label{font-size:11px;font-weight:600;color:var(--muted);letter-spacing:0.06em;text-transform:uppercase;margin-bottom:8px}
.field-input{display:flex;align-items:center;gap:12px;border:1.5px solid var(--border);border-radius:12px;padding:14px 16px;background:var(--light)}
.field-input svg{width:18px;height:18px;stroke:var(--slate);flex-shrink:0;fill:none;stroke-width:1.8;stroke-linecap:round}
.field-input span{font-size:14px;color:var(--muted)}
.forgot{font-size:12px;color:var(--orange);font-weight:500;text-align:right;margin-top:8px;cursor:pointer}
.btn-primary{width:100%;padding:17px;border-radius:14px;background:var(--orange);border:none;cursor:pointer;color:var(--white);font-size:15px;font-weight:700;font-family:'Sora',sans-serif;letter-spacing:0.02em;margin-top:28px;transition:background 0.2s,transform 0.1s;display:flex;align-items:center;justify-content:center;gap:8px}
.btn-primary:active{background:var(--orange2);transform:scale(0.98)}
.btn-primary svg{width:18px;height:18px;stroke:var(--white);fill:none;stroke-width:2.5;stroke-linecap:round}
.login-footer{margin-top:20px;text-align:center;font-size:11px;color:var(--muted)}
.login-footer span{color:var(--navy);font-weight:600}

#p2{background:var(--light)}
.home-header{background:var(--navy);padding:44px 24px 24px}
.home-topbar{display:flex;align-items:center;justify-content:space-between;margin-bottom:20px}
.avatar{width:42px;height:42px;border-radius:50%;background:var(--orange);display:flex;align-items:center;justify-content:center;font-size:14px;font-weight:700;color:var(--white)}
.bell-btn{width:42px;height:42px;border-radius:50%;background:rgba(255,255,255,0.1);display:flex;align-items:center;justify-content:center;position:relative;cursor:pointer;border:none}
.bell-btn svg{width:20px;height:20px;stroke:var(--white);fill:none;stroke-width:2;stroke-linecap:round}
.bell-dot{width:8px;height:8px;border-radius:50%;background:var(--orange);position:absolute;top:8px;right:8px;border:2px solid var(--navy)}
.home-greet-sub{font-size:12px;color:var(--slate);font-family:'IBM Plex Mono',monospace;margin-bottom:4px}
.home-greet{font-size:20px;font-weight:700;color:var(--white)}
.home-stats{display:flex;gap:12px;margin-top:20px}
.stat-chip{background:rgba(255,255,255,0.1);border-radius:12px;padding:12px 16px;flex:1;border:1px solid rgba(255,255,255,0.08)}
.stat-num{font-size:22px;font-weight:700;color:var(--white)}
.stat-lbl{font-size:10px;color:var(--slate);margin-top:1px;font-family:'IBM Plex Mono',monospace}
.home-grid{display:grid;grid-template-columns:1fr 1fr;gap:14px;padding:20px}
.menu-card{background:var(--white);border-radius:20px;padding:22px 18px;border:1px solid var(--border);cursor:pointer;transition:transform 0.15s;display:flex;flex-direction:column;gap:12px;min-height:150px}
.menu-card:active{transform:scale(0.97)}
.menu-card.orange{background:var(--orange);border-color:var(--orange2)}
.card-icon{width:44px;height:44px;border-radius:12px;display:flex;align-items:center;justify-content:center}
.menu-card:not(.orange) .card-icon{background:var(--light)}
.menu-card.orange .card-icon{background:rgba(255,255,255,0.2)}
.card-icon svg{width:22px;height:22px;fill:none;stroke-width:2;stroke-linecap:round;stroke-linejoin:round}
.menu-card:not(.orange) .card-icon svg{stroke:var(--navy)}
.menu-card.orange .card-icon svg{stroke:var(--white)}
.card-label{font-size:13px;font-weight:600;color:var(--text);line-height:1.35}
.menu-card.orange .card-label{color:var(--white)}
.card-count{font-size:10px;font-family:'IBM Plex Mono',monospace;color:var(--slate);margin-top:auto}
.menu-card.orange .card-count{color:rgba(255,255,255,0.7)}
.fab{position:sticky;bottom:24px;left:50%;transform:translateX(-50%);width:calc(100% - 40px);background:var(--navy);border-radius:16px;padding:16px;display:flex;align-items:center;justify-content:center;gap:10px;cursor:pointer;border:none;margin:0 20px}
.fab svg{width:20px;height:20px;stroke:var(--orange);fill:none;stroke-width:2.5;stroke-linecap:round}
.fab span{font-size:14px;font-weight:600;color:var(--white);font-family:'Sora',sans-serif}

#p3{background:var(--light)}
.p3-header{background:var(--navy);padding:44px 0 0}
.search-bar{display:flex;align-items:center;gap:10px;background:rgba(255,255,255,0.1);border-radius:12px;padding:12px 16px;margin:16px;border:1px solid rgba(255,255,255,0.1)}
.search-bar svg{width:18px;height:18px;stroke:var(--slate);fill:none;stroke-width:2;stroke-linecap:round}
.search-bar span{font-size:14px;color:var(--slate)}
.filter-btn{margin-left:auto;width:32px;height:32px;border-radius:8px;background:var(--orange);display:flex;align-items:center;justify-content:center;cursor:pointer;border:none}
.filter-btn svg{width:16px;height:16px;stroke:var(--white);fill:none;stroke-width:2.5}
.proj-list{padding:16px}
.proj-card{background:var(--white);border-radius:18px;padding:18px;margin-bottom:14px;border:1px solid var(--border);cursor:pointer;transition:transform 0.15s}
.proj-card:active{transform:scale(0.98)}
.proj-top{display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:10px}
.proj-name{font-size:15px;font-weight:600;color:var(--text)}
.status-tag{font-size:10px;font-weight:600;padding:4px 10px;border-radius:20px;font-family:'IBM Plex Mono',monospace}
.tag-green{background:#e8f5ed;color:var(--green)}
.tag-yellow{background:#fef8e7;color:var(--yellow)}
.tag-red{background:#fdecea;color:var(--red)}
.proj-addr{font-size:12px;color:var(--muted);display:flex;align-items:center;gap:5px;margin-bottom:12px}
.proj-addr svg{width:13px;height:13px;stroke:var(--slate);fill:none;stroke-width:2}
.map-thumb{height:80px;background:linear-gradient(135deg,#d4e3f7,#b8ccee);border-radius:12px;display:flex;align-items:center;justify-content:center;position:relative;overflow:hidden}
.map-grid{position:absolute;inset:0;background-image:linear-gradient(rgba(100,130,180,0.2) 1px,transparent 1px),linear-gradient(90deg,rgba(100,130,180,0.2) 1px,transparent 1px);background-size:20px 20px}
.map-pin{width:24px;height:24px;background:var(--orange);border-radius:50% 50% 50% 0;transform:rotate(-45deg);position:relative;z-index:2}
.proj-footer{display:flex;align-items:center;justify-content:space-between;margin-top:12px}
.proj-meta{font-size:11px;color:var(--muted);font-family:'IBM Plex Mono',monospace}
.chevron-r{width:28px;height:28px;border-radius:50%;background:var(--light);display:flex;align-items:center;justify-content:center}
.chevron-r svg{width:14px;height:14px;stroke:var(--navy);fill:none;stroke-width:2.5;stroke-linecap:round}

#p4{background:var(--light)}
.p4-header{background:var(--navy);padding:44px 0 20px}
.sub-list{padding:16px}
.sub-card{background:var(--white);border-radius:18px;padding:18px 20px;margin-bottom:14px;border:1px solid var(--border);cursor:pointer;transition:transform 0.15s}
.sub-card:active{transform:scale(0.98)}
.sub-top{display:flex;align-items:center;gap:14px;margin-bottom:10px}
.sub-icon{width:46px;height:46px;border-radius:14px;display:flex;align-items:center;justify-content:center;flex-shrink:0}
.sub-icon svg{width:22px;height:22px;fill:none;stroke-width:2;stroke-linecap:round;stroke-linejoin:round}
.sub-name{font-size:14px;font-weight:600;color:var(--text)}
.sub-tags{font-size:11px;color:var(--muted);margin-top:3px}
.sub-footer{display:flex;align-items:center;justify-content:space-between;border-top:1px solid var(--border);padding-top:12px}
.checklist-badge{background:var(--navy);color:var(--white);font-size:11px;font-weight:600;padding:4px 12px;border-radius:20px;font-family:'IBM Plex Mono',monospace}
.sub-arrow{width:28px;height:28px;border-radius:50%;background:var(--light);display:flex;align-items:center;justify-content:center}

#p5{background:var(--light)}
.p5-header{background:var(--navy);padding:44px 0 0}
.checklist-body{padding:16px}
.cl-progress{background:var(--white);border-radius:16px;padding:16px;margin-bottom:16px;border:1px solid var(--border)}
.cl-prog-label{display:flex;justify-content:space-between;font-size:12px;color:var(--muted);margin-bottom:8px}
.prog-bar{height:6px;background:var(--light);border-radius:3px}
.prog-fill{height:6px;background:var(--orange);border-radius:3px;width:35%}
.cl-item{background:var(--white);border-radius:18px;padding:18px;margin-bottom:14px;border:1px solid var(--border)}
.cl-item-header{display:flex;align-items:center;gap:10px;margin-bottom:14px}
.cl-num{width:28px;height:28px;border-radius:50%;background:var(--navy);display:flex;align-items:center;justify-content:center;font-size:11px;font-weight:700;color:var(--white);font-family:'IBM Plex Mono',monospace;flex-shrink:0}
.cl-item-name{font-size:14px;font-weight:600;color:var(--text)}
.pass-fail{display:grid;grid-template-columns:1fr 1fr;gap:10px;margin-bottom:14px}
.btn-pass{background:#e8f5ed;color:var(--green);border:2px solid var(--green);border-radius:12px;padding:14px;font-size:15px;font-weight:700;cursor:pointer;font-family:'Sora',sans-serif}
.btn-fail{background:#fdecea;color:var(--red);border:2px solid var(--red);border-radius:12px;padding:14px;font-size:15px;font-weight:700;cursor:pointer;font-family:'Sora',sans-serif}
.btn-pass.sel{background:var(--green);color:var(--white)}
.btn-fail.sel{background:var(--red);color:var(--white)}
.photo-box{border:2px dashed var(--border);border-radius:12px;padding:20px;display:flex;flex-direction:column;align-items:center;gap:6px;cursor:pointer}
.photo-box svg{width:28px;height:28px;stroke:var(--slate);fill:none;stroke-width:1.8;stroke-linecap:round}
.photo-box span{font-size:12px;color:var(--muted);text-align:center}
.remarks-area{width:100%;border:1.5px solid var(--border);border-radius:12px;padding:14px;font-size:13px;color:var(--text);font-family:'Sora',sans-serif;resize:none;min-height:80px;background:var(--light);margin-top:10px}
.submit-sticky{padding:16px;background:var(--white);border-top:1px solid var(--border)}
.btn-submit{width:100%;padding:17px;border-radius:14px;background:var(--orange);border:none;cursor:pointer;color:var(--white);font-size:15px;font-weight:700;font-family:'Sora',sans-serif;display:flex;align-items:center;justify-content:center;gap:8px}
.btn-submit svg{width:18px;height:18px;stroke:var(--white);fill:none;stroke-width:2.5}

#p6{background:var(--light)}
.p6-header{background:var(--navy);padding:44px 0 20px}
.ai-body{padding:16px}
.upload-zone{background:var(--white);border-radius:20px;padding:28px 20px;border:2px dashed var(--border);text-align:center;margin-bottom:16px;cursor:pointer}
.upload-zone svg{width:40px;height:40px;stroke:var(--slate);fill:none;stroke-width:1.8;stroke-linecap:round;margin-bottom:12px}
.upload-title{font-size:14px;font-weight:600;color:var(--text);margin-bottom:6px}
.upload-sub{font-size:12px;color:var(--muted);line-height:1.5}
.upload-btn{display:inline-block;margin-top:14px;background:var(--navy);color:var(--white);font-size:12px;font-weight:600;padding:8px 20px;border-radius:20px;font-family:'IBM Plex Mono',monospace}
.workflow-card{background:var(--white);border-radius:18px;padding:18px;border:1px solid var(--border);margin-bottom:16px}
.workflow-title{font-size:12px;font-weight:600;color:var(--muted);letter-spacing:0.06em;text-transform:uppercase;margin-bottom:14px;font-family:'IBM Plex Mono',monospace}
.wf-steps{display:flex;align-items:center}
.wf-step{display:flex;flex-direction:column;align-items:center;flex:1;position:relative}
.wf-dot{width:36px;height:36px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:700;font-family:'IBM Plex Mono',monospace;margin-bottom:8px;position:relative;z-index:1}
.wf-done{background:var(--navy);color:var(--white)}
.wf-active{background:var(--orange);color:var(--white)}
.wf-idle{background:var(--light);color:var(--muted);border:2px solid var(--border)}
.wf-label{font-size:10px;color:var(--muted);text-align:center;line-height:1.3;max-width:70px}
.stats-card{background:var(--navy);border-radius:18px;padding:18px;margin-bottom:16px}
.stats-row{display:flex;align-items:center;gap:14px}
.acc-text{position:absolute;inset:0;display:flex;flex-direction:column;align-items:center;justify-content:center}
.acc-num{font-size:14px;font-weight:700;color:var(--white);line-height:1}
.acc-pct{font-size:9px;color:var(--slate)}
.stats-info{flex:1}
.stats-label{font-size:10px;color:var(--slate);font-family:'IBM Plex Mono',monospace;margin-bottom:4px}
.stats-val{font-size:18px;font-weight:700;color:var(--white)}
.btn-ai{width:100%;padding:17px;border-radius:14px;background:var(--orange);border:none;cursor:pointer;color:var(--white);font-size:15px;font-weight:700;font-family:'Sora',sans-serif;display:flex;align-items:center;justify-content:center;gap:8px}
.btn-ai svg{width:18px;height:18px;fill:none;stroke:var(--white);stroke-width:2.5;stroke-linecap:round}

#p7{background:#1a1a2e;display:flex;flex-direction:column}
.p7-header{background:var(--navy);padding:44px 0 0;flex-shrink:0}
.canvas-area{flex:1;position:relative;min-height:320px;background:#111827;overflow:hidden}
.canvas-img{width:100%;height:100%;background:repeating-linear-gradient(0deg,rgba(255,255,255,0.03) 0px,rgba(255,255,255,0.03) 1px,transparent 1px,transparent 40px),repeating-linear-gradient(90deg,rgba(255,255,255,0.03) 0px,rgba(255,255,255,0.03) 1px,transparent 1px,transparent 40px),linear-gradient(160deg,#1e293b,#0f172a);display:flex;align-items:center;justify-content:center;position:relative}
.col-texture{position:absolute;width:90px;height:220px;background:linear-gradient(180deg,#4a5568,#374151,#2d3748,#4a5568,#374151);border-radius:4px;left:50%;top:50%;transform:translate(-50%,-50%)}
.crack-svg{position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);width:90px;height:220px}
.anno-toolbar{background:#0f172a;padding:14px 20px;border-top:1px solid rgba(255,255,255,0.08);display:flex;align-items:center;flex-shrink:0}
.tool-btn{flex:1;height:42px;border-radius:10px;border:none;cursor:pointer;display:flex;align-items:center;justify-content:center;background:transparent}
.tool-btn.active{background:rgba(255,107,0,0.2)}
.tool-btn svg{width:20px;height:20px;fill:none;stroke-width:2;stroke-linecap:round;stroke-linejoin:round}
.tool-btn:not(.active) svg{stroke:var(--slate)}
.tool-btn.active svg{stroke:var(--orange)}
.save-bar{background:#0f172a;padding:12px 16px;flex-shrink:0;border-top:1px solid rgba(255,255,255,0.06)}
.btn-save{width:100%;padding:15px;border-radius:12px;background:var(--orange);border:none;color:var(--white);font-size:14px;font-weight:700;font-family:'Sora',sans-serif;display:flex;align-items:center;justify-content:center;gap:8px;cursor:pointer}
.btn-save svg{width:16px;height:16px;stroke:var(--white);fill:none;stroke-width:2.5}
</style>

<div class="device">
  <div class="notch"><div class="notch-cam"></div><div class="notch-face"></div></div>
  <div class="screen">

    <!-- PAGE 1: LOGIN -->
    <div class="page active" id="p1">
      <div class="login-top">
        <div class="status-bar" style="color:rgba(255,255,255,0.7);padding-bottom:4px"><span>9:41</span><span>●●●○ 5G 🔋</span></div>
        <div class="logo-mark">
          <svg viewBox="0 0 24 24"><path d="M2 20h20M4 20V8l8-6 8 6v12"/><path d="M9 20v-6h6v6"/><path d="M9 11h6"/></svg>
        </div>
        <div class="logo-name">ConstructionHub</div>
        <div class="logo-sub">CONSTRUCTION QUALITY CONTROL</div>
      </div>
      <div class="login-body">
        <div class="login-card">
          <div style="margin-bottom:24px">
            <div style="font-size:18px;font-weight:700;color:var(--text)">Welcome back</div>
            <div style="font-size:13px;color:var(--muted);margin-top:3px">Sign in to your enterprise account</div>
          </div>
          <div class="field-wrap">
            <div class="field-label">Corporate Email</div>
            <div class="field-input">
              <svg viewBox="0 0 24 24"><rect x="2" y="4" width="20" height="16" rx="2"/><polyline points="2,4 12,13 22,4"/></svg>
              <span>engineer@company.com</span>
            </div>
          </div>
          <div class="field-wrap">
            <div class="field-label">Password</div>
            <div class="field-input">
              <svg viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
              <span>••••••••••••</span>
            </div>
            <div class="forgot">Forgot Password?</div>
          </div>
          <button class="btn-primary" onclick="goto(1)">
            <svg viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
            Secure Login
          </button>
        </div>
        <div class="login-footer">Protected by enterprise SSO · <span>v2.4.1</span></div>
      </div>
    </div>

    <!-- PAGE 2: HOME -->
    <div class="page" id="p2">
      <div class="home-header">
        <div class="status-bar"><span>9:41</span><span>●●●○ 5G 🔋</span></div>
        <div class="home-topbar">
          <div style="display:flex;align-items:center;gap:10px">
            <div class="avatar">PM</div>
            <div>
              <div class="home-greet-sub">Good morning,</div>
              <div class="home-greet">Project Manager</div>
            </div>
          </div>
          <button class="bell-btn"><svg viewBox="0 0 24 24"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg><div class="bell-dot"></div></button>
        </div>
        <div style="display:flex;align-items:center;gap:6px;margin-bottom:16px">
          <div style="width:24px;height:24px;border-radius:6px;background:var(--orange);display:flex;align-items:center;justify-content:center">
            <svg width="14" height="14" viewBox="0 0 24 24" style="stroke:white;fill:none;stroke-width:2.5;stroke-linecap:round"><path d="M2 20h20M4 20V8l8-6 8 6v12"/></svg>
          </div>
          <span style="font-size:15px;font-weight:700;color:var(--white)">ConstructionHub</span>
        </div>
        <div class="home-stats">
          <div class="stat-chip"><div class="stat-num">12</div><div class="stat-lbl">ACTIVE SITES</div></div>
          <div class="stat-chip"><div class="stat-num">847</div><div class="stat-lbl">INSPECTIONS</div></div>
          <div class="stat-chip"><div class="stat-num">94%</div><div class="stat-lbl">PASS RATE</div></div>
        </div>
      </div>
      <div class="home-grid">
        <div class="menu-card" onclick="goto(2)">
          <div class="card-icon"><svg viewBox="0 0 24 24"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"/></svg></div>
          <div class="card-label">Projects Portal</div>
          <div class="card-count">12 active sites →</div>
        </div>
        <div class="menu-card" onclick="goto(4)">
          <div class="card-icon"><svg viewBox="0 0 24 24"><path d="M9 5H7a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2"/><rect x="9" y="3" width="6" height="4" rx="1"/><line x1="9" y1="12" x2="15" y2="12"/><line x1="9" y1="16" x2="12" y2="16"/></svg></div>
          <div class="card-label">Daily Inspection Reports</div>
          <div class="card-count">3 pending today →</div>
        </div>
        <div class="menu-card orange" onclick="goto(5)">
          <div class="card-icon"><svg viewBox="0 0 24 24"><rect x="2" y="3" width="20" height="14" rx="2"/><path d="M8 21h8M12 17v4"/><circle cx="12" cy="10" r="2"/><path d="M9 10c0-1.7 1.3-3 3-3"/><path d="M15 10c0 1.7-1.3 3-3 3"/></svg></div>
          <div class="card-label">AI Image Processing</div>
          <div class="card-count">94.2% accuracy →</div>
        </div>
        <div class="menu-card orange" onclick="goto(6)">
          <div class="card-icon"><svg viewBox="0 0 24 24"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><path d="m21 15-5-5L5 21"/></svg></div>
          <div class="card-label">Image Annotation Tool</div>
          <div class="card-count">Open canvas →</div>
        </div>
      </div>
      <div style="padding:0 20px 24px">
        <button class="fab" onclick="goto(5)">
          <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
          <span>⚡ Instant Quick Scan</span>
        </button>
      </div>
    </div>

    <!-- PAGE 3: PROJECTS LIST -->
    <div class="page" id="p3">
      <div class="p3-header">
        <div class="status-bar"><span>9:41</span><span>●●●○ 5G 🔋</span></div>
        <div class="navbar">
          <button class="nav-back" onclick="goto(1)"><svg viewBox="0 0 24 24"><polyline points="15,18 9,12 15,6"/></svg></button>
          <div><div class="nav-title">Active Sites</div><div class="nav-breadcrumb">CONSTRUCTIONHUB · 12 PROJECTS</div></div>
        </div>
        <div class="search-bar">
          <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
          <span>Search projects...</span>
          <button class="filter-btn"><svg viewBox="0 0 24 24"><line x1="4" y1="6" x2="20" y2="6"/><line x1="8" y1="12" x2="16" y2="12"/><line x1="11" y1="18" x2="13" y2="18"/></svg></button>
        </div>
      </div>
      <div class="proj-list">
        <div class="proj-card" onclick="goto(3)">
          <div class="proj-top"><div class="proj-name">Skyline Towers — Block A</div><div class="status-tag tag-green">IN PROGRESS</div></div>
          <div class="proj-addr"><svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>Sector 18, Guwahati · Zone A</div>
          <div class="map-thumb"><div class="map-grid"></div><div class="map-pin"></div></div>
          <div class="proj-footer"><div class="proj-meta">Updated 2h ago · 14 checklists</div><div class="chevron-r"><svg viewBox="0 0 24 24"><polyline points="9,18 15,12 9,6"/></svg></div></div>
        </div>
        <div class="proj-card" onclick="goto(3)">
          <div class="proj-top"><div class="proj-name">Metro Depot Expansion</div><div class="status-tag tag-yellow">PAUSED</div></div>
          <div class="proj-addr"><svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>NH-37 Bypass, Guwahati</div>
          <div class="map-thumb" style="background:linear-gradient(135deg,#d4e8d4,#b8d4b8)"><div class="map-grid"></div><div class="map-pin" style="background:var(--yellow)"></div></div>
          <div class="proj-footer"><div class="proj-meta">Updated 5h ago · 9 checklists</div><div class="chevron-r"><svg viewBox="0 0 24 24"><polyline points="9,18 15,12 9,6"/></svg></div></div>
        </div>
        <div class="proj-card" onclick="goto(3)">
          <div class="proj-top"><div class="proj-name">IIT Gate Complex — Phase 2</div><div class="status-tag tag-red">CRITICAL</div></div>
          <div class="proj-addr"><svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>IIT Guwahati Campus</div>
          <div class="map-thumb" style="background:linear-gradient(135deg,#f7d4d4,#eeb8b8)"><div class="map-grid"></div><div class="map-pin" style="background:var(--red)"></div></div>
          <div class="proj-footer"><div class="proj-meta">Updated 1h ago · 21 checklists</div><div class="chevron-r"><svg viewBox="0 0 24 24"><polyline points="9,18 15,12 9,6"/></svg></div></div>
        </div>
      </div>
    </div>

    <!-- PAGE 4: SUB-TYPES -->
    <div class="page" id="p4">
      <div class="p4-header">
        <div class="status-bar"><span>9:41</span><span>●●●○ 5G 🔋</span></div>
        <div class="navbar">
          <button class="nav-back" onclick="goto(2)"><svg viewBox="0 0 24 24"><polyline points="15,18 9,12 15,6"/></svg></button>
          <div><div class="nav-title">Phase Sub-Types</div><div class="nav-breadcrumb">SKYLINE TOWERS › BLOCK A</div></div>
        </div>
      </div>
      <div class="sub-list">
        <div class="sub-card" onclick="goto(4)">
          <div class="sub-top">
            <div class="sub-icon" style="background:#e8f0fb"><svg viewBox="0 0 24 24" style="stroke:var(--navy)"><rect x="2" y="3" width="20" height="18" rx="2"/><line x1="2" y1="9" x2="22" y2="9"/><line x1="8" y1="3" x2="8" y2="9"/></svg></div>
            <div><div class="sub-name">Civil & Structural Works</div><div class="sub-tags">Concrete · Foundation · Rebar</div></div>
          </div>
          <div class="sub-footer"><div class="checklist-badge">08 CHECKLISTS</div><div class="sub-arrow"><svg viewBox="0 0 24 24" width="14" height="14" style="stroke:var(--navy);fill:none;stroke-width:2.5;stroke-linecap:round"><polyline points="9,18 15,12 9,6"/></svg></div></div>
        </div>
        <div class="sub-card" onclick="goto(4)">
          <div class="sub-top">
            <div class="sub-icon" style="background:#fef3e8"><svg viewBox="0 0 24 24" style="stroke:var(--orange)"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9,22 9,12 15,12 15,22"/></svg></div>
            <div><div class="sub-name">Finishing & Brickwork</div><div class="sub-tags">Plastering · Tiling · Waterproofing</div></div>
          </div>
          <div class="sub-footer"><div class="checklist-badge">06 CHECKLISTS</div><div class="sub-arrow"><svg viewBox="0 0 24 24" width="14" height="14" style="stroke:var(--navy);fill:none;stroke-width:2.5;stroke-linecap:round"><polyline points="9,18 15,12 9,6"/></svg></div></div>
        </div>
        <div class="sub-card" onclick="goto(4)">
          <div class="sub-top">
            <div class="sub-icon" style="background:#e8f5ed"><svg viewBox="0 0 24 24" style="stroke:var(--green)"><path d="M18 20V10"/><path d="M12 20V4"/><path d="M6 20v-6"/></svg></div>
            <div><div class="sub-name">MEP Services</div><div class="sub-tags">Mechanical · Electrical · Plumbing</div></div>
          </div>
          <div class="sub-footer"><div class="checklist-badge">11 CHECKLISTS</div><div class="sub-arrow"><svg viewBox="0 0 24 24" width="14" height="14" style="stroke:var(--navy);fill:none;stroke-width:2.5;stroke-linecap:round"><polyline points="9,18 15,12 9,6"/></svg></div></div>
        </div>
        <div class="sub-card" onclick="goto(4)">
          <div class="sub-top">
            <div class="sub-icon" style="background:#fdecea"><svg viewBox="0 0 24 24" style="stroke:var(--red)"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg></div>
            <div><div class="sub-name">Safety & HSE Compliance</div><div class="sub-tags">Barricades · PPE Logs · Signage</div></div>
          </div>
          <div class="sub-footer"><div class="checklist-badge">05 CHECKLISTS</div><div class="sub-arrow"><svg viewBox="0 0 24 24" width="14" height="14" style="stroke:var(--navy);fill:none;stroke-width:2.5;stroke-linecap:round"><polyline points="9,18 15,12 9,6"/></svg></div></div>
        </div>
      </div>
    </div>

    <!-- PAGE 5: CHECKLIST -->
    <div class="page" id="p5">
      <div class="p5-header">
        <div class="status-bar"><span>9:41</span><span>●●●○ 5G 🔋</span></div>
        <div class="navbar">
          <button class="nav-back" onclick="goto(3)"><svg viewBox="0 0 24 24"><polyline points="15,18 9,12 15,6"/></svg></button>
          <div><div class="nav-title">Concrete Pouring Audit</div><div class="nav-breadcrumb">CIVIL WORKS › CHECKLIST</div></div>
        </div>
      </div>
      <div class="checklist-body">
        <div class="cl-progress">
          <div class="cl-prog-label"><span style="font-size:12px;font-weight:600;color:var(--text)">Completion</span><span>1 of 4 done</span></div>
          <div class="prog-bar"><div class="prog-fill"></div></div>
        </div>
        <div class="cl-item">
          <div class="cl-item-header"><div class="cl-num">01</div><div class="cl-item-name">Slump Test Verification</div></div>
          <div class="pass-fail">
            <button class="btn-pass sel" id="pf1p">✓ PASS</button>
            <button class="btn-fail" id="pf1f">✗ FAIL</button>
          </div>
          <div class="photo-box"><svg viewBox="0 0 24 24"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="12" cy="12" r="3"/><path d="M3 9h2l2-3h10l2 3h2"/></svg><span>📷 Capture Audit Photo</span></div>
        </div>
        <div class="cl-item">
          <div class="cl-item-header"><div class="cl-num">02</div><div class="cl-item-name">Rebar Spacing & Cover Depth</div></div>
          <div class="pass-fail">
            <button class="btn-pass" id="pf2p">✓ PASS</button>
            <button class="btn-fail" id="pf2f">✗ FAIL</button>
          </div>
          <div class="photo-box"><svg viewBox="0 0 24 24"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="12" cy="12" r="3"/><path d="M3 9h2l2-3h10l2 3h2"/></svg><span>📷 Capture Audit Photo</span></div>
        </div>
        <div class="cl-item">
          <div class="cl-item-header"><div class="cl-num">03</div><div class="cl-item-name">Formwork Stability Check</div></div>
          <div class="pass-fail">
            <button class="btn-pass" id="pf3p">✓ PASS</button>
            <button class="btn-fail" id="pf3f">✗ FAIL</button>
          </div>
          <div class="photo-box"><svg viewBox="0 0 24 24"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="12" cy="12" r="3"/><path d="M3 9h2l2-3h10l2 3h2"/></svg><span>📷 Capture Audit Photo</span></div>
        </div>
        <div class="cl-item" style="border:none;background:transparent;padding:0">
          <textarea class="remarks-area" placeholder="Site Engineer Remarks..."></textarea>
        </div>
        <div style="height:90px"></div>
      </div>
      <div class="submit-sticky">
        <button class="btn-submit"><svg viewBox="0 0 24 24"><polyline points="20,6 9,17 4,12"/></svg>Submit & Timestamp Log</button>
      </div>
    </div>

    <!-- PAGE 6: AI -->
    <div class="page" id="p6">
      <div class="p6-header">
        <div class="status-bar"><span>9:41</span><span>●●●○ 5G 🔋</span></div>
        <div class="navbar">
          <button class="nav-back" onclick="goto(1)"><svg viewBox="0 0 24 24"><polyline points="15,18 9,12 15,6"/></svg></button>
          <div><div class="nav-title">AI Image Processing</div><div class="nav-breadcrumb">CONSTRUCTIONHUB · DEFECT ENGINE</div></div>
        </div>
      </div>
      <div class="ai-body">
        <div class="upload-zone">
          <svg viewBox="0 0 24 24"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><path d="m21 15-5-5L5 21"/><path d="M14 5l3 3-3 3"/></svg>
          <div class="upload-title">Upload Site Photo for Analysis</div>
          <div class="upload-sub">AI Crack & Honeycombing Detection<br>Supports JPG, PNG, HEIC · Max 25MB</div>
          <div class="upload-btn">+ CHOOSE PHOTO</div>
        </div>
        <div class="workflow-card">
          <div class="workflow-title">PROCESSING PIPELINE</div>
          <div class="wf-steps">
            <div class="wf-step"><div class="wf-dot wf-done">1</div><div class="wf-label">Image Ingestion</div></div>
            <div style="flex:1;height:2px;background:var(--navy);margin-bottom:24px"></div>
            <div class="wf-step"><div class="wf-dot wf-active">2</div><div class="wf-label">Cloud ML Detection</div></div>
            <div style="flex:1;height:2px;background:var(--border);margin-bottom:24px"></div>
            <div class="wf-step"><div class="wf-dot wf-idle">3</div><div class="wf-label">Defect Report</div></div>
          </div>
        </div>
        <div class="stats-card">
          <div style="font-size:11px;color:var(--slate);font-family:'IBM Plex Mono',monospace;margin-bottom:12px">REAL-TIME AI PERFORMANCE</div>
          <div class="stats-row">
            <div style="position:relative;width:72px;height:72px;flex-shrink:0">
              <svg width="72" height="72" viewBox="0 0 72 72"><circle cx="36" cy="36" r="28" fill="none" stroke="rgba(255,255,255,0.1)" stroke-width="8"/><circle cx="36" cy="36" r="28" fill="none" stroke="#FF6B00" stroke-width="8" stroke-dasharray="158 176" stroke-linecap="round" transform="rotate(-90 36 36)"/></svg>
              <div class="acc-text"><span class="acc-num">94.2</span><span class="acc-pct">%</span></div>
            </div>
            <div class="stats-info">
              <div class="stats-label">DEFECT IDENTIFICATION ACCURACY</div>
              <div class="stats-val">94.2%</div>
              <div style="font-size:11px;color:var(--slate);margin-top:6px;font-family:'IBM Plex Mono',monospace">2,841 images · 12ms avg</div>
            </div>
          </div>
          <div style="display:grid;grid-template-columns:1fr 1fr;gap:10px;margin-top:14px">
            <div style="background:rgba(255,255,255,0.06);border-radius:10px;padding:12px"><div style="font-size:10px;color:var(--slate);font-family:'IBM Plex Mono',monospace">CRACKS</div><div style="font-size:18px;font-weight:700;color:var(--white);margin-top:2px">96.1%</div></div>
            <div style="background:rgba(255,255,255,0.06);border-radius:10px;padding:12px"><div style="font-size:10px;color:var(--slate);font-family:'IBM Plex Mono',monospace">HONEYCOMB</div><div style="font-size:18px;font-weight:700;color:var(--white);margin-top:2px">91.8%</div></div>
          </div>
        </div>
        <button class="btn-ai" onclick="goto(6)"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>Run AI Diagnosis</button>
        <div style="height:24px"></div>
      </div>
    </div>

    <!-- PAGE 7: ANNOTATION -->
    <div class="page" id="p7" style="display:flex;flex-direction:column;height:100%">
      <div class="p7-header">
        <div class="status-bar"><span>9:41</span><span>●●●○ 5G 🔋</span></div>
        <div class="navbar">
          <button class="nav-back" onclick="goto(1)"><svg viewBox="0 0 24 24"><polyline points="15,18 9,12 15,6"/></svg></button>
          <div><div class="nav-title">Image Annotation</div><div class="nav-breadcrumb">CONSTRUCTIONHUB · COLUMN C-4</div></div>
          <button style="margin-left:auto;background:rgba(255,255,255,0.1);border:none;border-radius:8px;padding:6px 12px;color:var(--white);font-size:11px;font-weight:600;cursor:pointer;font-family:'IBM Plex Mono',monospace">UNDO</button>
        </div>
      </div>
      <div class="canvas-area" style="flex:1;min-height:0">
        <div class="canvas-img">
          <div class="col-texture"></div>
          <svg class="crack-svg" viewBox="0 0 90 220">
            <path d="M45,40 L38,70 L52,90 L40,120 L55,145 L44,170" stroke="#6b7280" stroke-width="1.5" fill="none" opacity="0.4"/>
            <path d="M38,70 L25,80 L30,95" stroke="#6b7280" stroke-width="1" fill="none" opacity="0.3"/>
            <path d="M52,90 L65,100 L60,115" stroke="#6b7280" stroke-width="1" fill="none" opacity="0.3"/>
            <path d="M35,50 Q45,55 55,50 Q50,60 55,70 Q45,65 35,70 Q40,60 35,50Z" fill="#4b5563" opacity="0.6"/>
            <path d="M30,130 Q40,132 52,128 Q55,140 50,148 Q40,146 32,148 Q28,138 30,130Z" fill="#4b5563" opacity="0.5"/>
          </svg>
          <div style="position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);width:100px;height:180px">
            <div style="position:absolute;inset:0;border:2.5px solid #ef4444;border-radius:4px"></div>
            <div style="position:absolute;top:-32px;left:50%;transform:translateX(-50%);background:#ef4444;color:white;font-size:9px;font-weight:700;padding:4px 10px;border-radius:6px;font-family:'IBM Plex Mono',monospace;white-space:nowrap">⚠ Concrete Honeycombing</div>
            <div style="position:absolute;top:-4px;left:50%;width:2px;height:4px;background:#ef4444;transform:translateX(-50%)"></div>
          </div>
          <div style="position:absolute;bottom:12px;left:12px;background:rgba(0,0,0,0.6);color:#94a3b8;font-size:10px;padding:4px 10px;border-radius:6px;font-family:'IBM Plex Mono',monospace">COLUMN C-4 · Level 3</div>
          <div style="position:absolute;top:12px;right:12px;background:rgba(239,68,68,0.15);border:1px solid rgba(239,68,68,0.4);color:#ef4444;font-size:10px;padding:4px 10px;border-radius:6px;font-family:'IBM Plex Mono',monospace">1 DEFECT TAGGED</div>
        </div>
      </div>
      <div class="anno-toolbar">
        <button class="tool-btn"><svg viewBox="0 0 24 24" width="20" height="20" style="stroke:#8B9DB5;fill:none;stroke-width:2"><path d="M4 4l7 18 3-7 7-3z"/></svg></button>
        <button class="tool-btn active"><svg viewBox="0 0 24 24" width="20" height="20" style="stroke:var(--orange);fill:none;stroke-width:2"><rect x="3" y="3" width="18" height="18" rx="2"/></svg></button>
        <button class="tool-btn"><svg viewBox="0 0 24 24" width="20" height="20" style="stroke:#8B9DB5;fill:none;stroke-width:2"><path d="M3 17c4-8 9-8 12-4s6 4 6-2"/></svg></button>
        <button class="tool-btn"><svg viewBox="0 0 24 24" width="20" height="20" style="stroke:#8B9DB5;fill:none;stroke-width:2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg></button>
        <button class="tool-btn" style="flex:0.7"><div style="width:20px;height:20px;border-radius:50%;background:var(--orange);border:2px solid rgba(255,255,255,0.3)"></div></button>
      </div>
      <div class="save-bar">
        <button class="btn-save"><svg viewBox="0 0 24 24"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><polyline points="17,21 17,13 7,13 7,21"/><polyline points="7,3 7,8 15,8"/></svg>Save & Export Canvas</button>
      </div>
    </div>

  </div>
</div>

<div style="display:flex;gap:6px;justify-content:center;margin-top:16px;flex-wrap:wrap;max-width:400px;margin-left:auto;margin-right:auto">
  <button onclick="goto(0)" class="nav-tab" data-p="0" style="background:var(--navy);color:white;border:none;border-radius:20px;padding:6px 14px;font-size:11px;font-weight:600;cursor:pointer;font-family:'IBM Plex Mono',monospace">LOGIN</button>
  <button onclick="goto(1)" class="nav-tab" data-p="1" style="background:#e8ecf1;color:#6b7c93;border:none;border-radius:20px;padding:6px 14px;font-size:11px;font-weight:600;cursor:pointer;font-family:'IBM Plex Mono',monospace">HOME</button>
  <button onclick="goto(2)" class="nav-tab" data-p="2" style="background:#e8ecf1;color:#6b7c93;border:none;border-radius:20px;padding:6px 14px;font-size:11px;font-weight:600;cursor:pointer;font-family:'IBM Plex Mono',monospace">PROJECTS</button>
  <button onclick="goto(3)" class="nav-tab" data-p="3" style="background:#e8ecf1;color:#6b7c93;border:none;border-radius:20px;padding:6px 14px;font-size:11px;font-weight:600;cursor:pointer;font-family:'IBM Plex Mono',monospace">SUB-TYPES</button>
  <button onclick="goto(4)" class="nav-tab" data-p="4" style="background:#e8ecf1;color:#6b7c93;border:none;border-radius:20px;padding:6px 14px;font-size:11px;font-weight:600;cursor:pointer;font-family:'IBM Plex Mono',monospace">CHECKLIST</button>
  <button onclick="goto(5)" class="nav-tab" data-p="5" style="background:#e8ecf1;color:#6b7c93;border:none;border-radius:20px;padding:6px 14px;font-size:11px;font-weight:600;cursor:pointer;font-family:'IBM Plex Mono',monospace">AI</button>
  <button onclick="goto(6)" class="nav-tab" data-p="6" style="background:#e8ecf1;color:#6b7c93;border:none;border-radius:20px;padding:6px 14px;font-size:11px;font-weight:600;cursor:pointer;font-family:'IBM Plex Mono',monospace">ANNOTATE</button>
</div>

<script>
const pages=['p1','p2','p3','p4','p5','p6','p7'];
const tabs=document.querySelectorAll('.nav-tab');
let cur=0;
function goto(idx){
  document.getElementById(pages[cur]).classList.remove('active');
  cur=idx;
  const pg=document.getElementById(pages[cur]);
  pg.classList.add('active');
  pg.scrollTop=0;
  tabs.forEach((t,i)=>{
    if(i===idx){t.style.background='var(--navy)';t.style.color='white'}
    else{t.style.background='#e8ecf1';t.style.color='#6b7c93'}
  });
}
function setupPF(n){
  const p=document.getElementById('pf'+n+'p');
  const f=document.getElementById('pf'+n+'f');
  if(!p)return;
  p.onclick=()=>{p.classList.add('sel');f.classList.remove('sel')};
  f.onclick=()=>{f.classList.add('sel');p.classList.remove('sel')};
}
[1,2,3].forEach(setupPF);
</script>
