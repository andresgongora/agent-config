# Lifecycle + load-time examples

Source: https://docs.obsidian.md/plugins/guides/lifecycle-management and https://docs.obsidian.md/plugins/guides/load-time

Backing examples for Core rules on cleanup and startup cost.

## Cleanup: use Component registration, not manual add/remove

Bad — leak, listener survives plugin unload:

```ts
class MyPlugin extends Plugin {
  onResize() { console.debug("resized"); }
  onload() {
    window.addEventListener("resize", this.onResize);
  }
  // no onunload cleanup -> listener never removed
}
```

Works but tedious/error-prone (manual mirror-cleanup):

```ts
class MyPlugin extends Plugin {
  onResize() { console.debug("resized"); }
  onload() {
    window.addEventListener("resize", this.onResize);
  }
  onunload() {
    window.removeEventListener("resize", this.onResize);
  }
}
```

Correct — `registerDomEvent` auto-cleans on unload:

```ts
class MyPlugin extends Plugin {
  onResize() { console.debug("resized"); }
  onload() {
    this.registerDomEvent(window, "resize", this.onResize);
  }
}
```

Same pattern for vault/workspace events and intervals:

```ts
this.registerEvent(
  this.app.vault.on("modify", (file) => {
    console.debug("modified:", file.path);
  })
);

const id = window.setInterval(() => { /* periodic task */ }, 60_000);
this.registerInterval(id);
```

## Load time: keep `onload` cheap, defer real work

Bad — heavy/data work directly in `onload` delays app startup:

```ts
class MyPlugin extends Plugin {
  async onload() {
    await this.scanEntireVaultAndBuildIndex(); // blocks startup
    this.addCommand({ id: "foo", name: "Foo", callback: () => {} });
  }
}
```

Correct — registrations only in `onload`, heavy work deferred:

```ts
class MyPlugin extends Plugin {
  onload() {
    this.addCommand({ id: "foo", name: "Foo", callback: () => {} });
    this.app.workspace.onLayoutReady(() => {
      this.scanEntireVaultAndBuildIndex(); // runs after Obsidian finishes loading
    });
  }
}
```

## Pitfall: `vault.on('create')` fires for every pre-existing file at vault init

Option A — guard inside callback:

```ts
class MyPlugin extends Plugin {
  onload() {
    this.registerEvent(this.app.vault.on("create", this.onCreate, this));
  }
  onCreate(file: TAbstractFile) {
    if (!this.app.workspace.layoutReady) return; // still loading, ignore
    // real new-file handling here
  }
}
```

Option B — register the handler only after layout ready:

```ts
class MyPlugin extends Plugin {
  onload() {
    this.app.workspace.onLayoutReady(() => {
      this.registerEvent(this.app.vault.on("create", this.onCreate, this));
    });
  }
  onCreate(file: TAbstractFile) {
    // safe: registered post-layout, no backlog of existing files
  }
}
```
