// import { tool } from "@opencode-ai/plugin"
// import { execSync } from "child_process"

// /** Helper to run git commands with error handling */
// function git(command: string): string {
//   try {
//     return execSync(`git ${command}`, { encoding: "utf-8", stdio: ["pipe", "pipe", "pipe"] }).trim()
//   } catch (error: any) {
//     const stderr = error.stderr?.trim() || ""
//     const msg = stderr || error.message || "Unknown git error"
//     throw new Error(msg)
//   }
// }

// /** Safe git execution - returns null on error instead of throwing */
// function gitSafe(command: string): string | null {
//   try {
//     return execSync(`git ${command}`, { encoding: "utf-8", stdio: ["pipe", "pipe", "pipe"] }).trim()
//   } catch {
//     return null
//   }
// }

// /** Validate branch name (prevent injection and invalid names). Returns sanitized name or null if invalid. */
// function validateBranchName(name: string | undefined): string | null {
//   if (!name || typeof name !== "string") return null
//   const trimmed = name.trim()
//   if (!trimmed) return null
//   if (/^[-.]|[~^:\s\\]|\.\.|\.$|@\{|\/\//.test(trimmed) || trimmed.endsWith(".lock")) {
//     return null
//   }
//   return trimmed
// }

// /** Validate file paths (basic sanitization). Returns sanitized array or null if any invalid. */
// function validateFilePaths(files: string[] | undefined): string[] | null {
//   if (!Array.isArray(files) || files.length === 0) return null
//   const result: string[] = []
//   for (const f of files) {
//     if (typeof f !== "string" || f.includes("\0") || f.trim() === "") {
//       return null
//     }
//     result.push(f.trim())
//   }
//   return result
// }

// /** Escape string for shell (single-quote style) */
// function escapeForShell(str: string): string {
//   return "'" + str.replace(/'/g, "'\\''") + "'"
// }

// // =============================================================================
// // Repository Info
// // =============================================================================

// export const isGitRepository = tool({
//   description: "Check if current directory is inside a git repository.",
//   args: {},
//   async execute() {
//     return gitSafe("rev-parse --is-inside-work-tree") === "true"
//   },
// })

// export const getRemotes = tool({
//   description: "List all configured remote repositories with their URLs.",
//   args: {},
//   async execute() {
//     const output = gitSafe("remote -v")
//     if (!output) return []
//     const remotes = new Map<string, { name: string; fetchUrl?: string; pushUrl?: string }>()
//     for (const line of output.split("\n")) {
//       const match = line.match(/^(\S+)\s+(\S+)\s+\((fetch|push)\)$/)
//       if (match) {
//         const [, name, url, type] = match
//         if (!remotes.has(name)) remotes.set(name, { name })
//         const remote = remotes.get(name)!
//         if (type === "fetch") remote.fetchUrl = url
//         else remote.pushUrl = url
//       }
//     }
//     return Array.from(remotes.values())
//   },
// })

// export const getDefaultBranch = tool({
//   description: "Get the default branch name of the remote (usually 'main' or 'master').",
//   args: {
//     remote: tool.schema.string().optional().describe("Remote name (default: 'origin')"),
//   },
//   async execute(args) {
//     const remote = args.remote ?? "origin"
//     if (!/^[\w.-]+$/.test(remote)) {
//       throw new Error(`Invalid remote name: '${remote}'`)
//     }
//     const ref = gitSafe(`symbolic-ref refs/remotes/${remote}/HEAD`)
//     if (ref) {
//       return ref.replace(`refs/remotes/${remote}/`, "")
//     }
//     for (const branch of ["main", "master", "develop", "trunk"]) {
//       if (gitSafe(`rev-parse --verify refs/remotes/${remote}/${branch}`) !== null) {
//         return branch
//       }
//     }
//     const remoteInfo = gitSafe(`remote show ${remote}`)
//     if (remoteInfo) {
//       const match = remoteInfo.match(/HEAD branch:\s*(\S+)/)
//       if (match) return match[1]
//     }
//     return null
//   },
// })

// // =============================================================================
// // Branch Info
// // =============================================================================

// export const getCurrentBranch = tool({
//   description: "Get current branch name. Returns 'HEAD' if in detached HEAD state.",
//   args: {},
//   async execute() {
//     return gitSafe("rev-parse --abbrev-ref HEAD")
//   },
// })

// export const listBranches = tool({
//   description: "List branches. Returns array of branch names.",
//   args: {
//     remote: tool.schema.boolean().optional().describe("Include remote branches (default: false)"),
//     all: tool.schema.boolean().optional().describe("Include both local and remote branches (default: false)"),
//   },
//   async execute(args) {
//     const remote = args.remote ?? false
//     const all = args.all ?? false
//     const flag = all ? "-a" : remote ? "-r" : ""
//     const output = gitSafe(`branch ${flag} --format='%(refname:short)'`)
//     if (!output) return []
//     return output.split("\n").map(b => b.trim()).filter(Boolean)
//   },
// })

// export const getBranchStatus = tool({
//   description: "Get current branch's ahead/behind count relative to its upstream.",
//   args: {},
//   async execute() {
//     const output = gitSafe("rev-list --left-right --count @{upstream}...HEAD")
//     if (!output) return null
//     const parts = output.split(/\s+/)
//     if (parts.length !== 2) return null
//     const [behind, ahead] = parts.map(Number)
//     if (isNaN(behind) || isNaN(ahead)) return null
//     return { ahead, behind }
//   },
// })

// export const getCommitsOnBranch = tool({
//   description: "List commits on current branch not in the base branch.",
//   args: {
//     baseBranch: tool.schema.string().optional().describe("Base branch to compare against (default: 'main')"),
//     limit: tool.schema.number().optional().describe("Maximum commits to return (default: 50)"),
//   },
//   async execute(args) {
//     let baseBranch = args.baseBranch ?? "main"
//     let limit = args.limit ?? 50
//     if (typeof limit !== "number" || limit < 1) limit = 50
//     if (limit > 500) limit = 500
//     if (gitSafe(`rev-parse --verify ${baseBranch}`) === null) {
//       if (gitSafe(`rev-parse --verify origin/${baseBranch}`) !== null) {
//         baseBranch = `origin/${baseBranch}`
//       } else {
//         return []
//       }
//     }
//     const output = gitSafe(`log --oneline ${baseBranch}..HEAD -n ${limit}`)
//     if (!output) return []
//     return output.split("\n").filter(Boolean).map(line => {
//       const spaceIdx = line.indexOf(" ")
//       if (spaceIdx === -1) return { hash: line, message: "" }
//       return { hash: line.slice(0, spaceIdx), message: line.slice(spaceIdx + 1) }
//     })
//   },
// })

// export const countCommitsOnBranch = tool({
//   description: "Count commits on current branch not in the base branch.",
//   args: {
//     baseBranch: tool.schema.string().optional().describe("Base branch to compare against (default: 'main')"),
//   },
//   async execute(args) {
//     let baseBranch = args.baseBranch ?? "main"
//     if (gitSafe(`rev-parse --verify ${baseBranch}`) === null) {
//       if (gitSafe(`rev-parse --verify origin/${baseBranch}`) !== null) {
//         baseBranch = `origin/${baseBranch}`
//       } else {
//         return 0
//       }
//     }
//     const output = gitSafe(`rev-list --count ${baseBranch}..HEAD`)
//     if (!output) return 0
//     const count = parseInt(output, 10)
//     return isNaN(count) ? 0 : count
//   },
// })

// // =============================================================================
// // Working Tree Status
// // =============================================================================

// export const getStatus = tool({
//   description: "Get working tree status with file lists for staged, unstaged, untracked, and conflicts.",
//   args: {},
//   async execute() {
//     const output = gitSafe("status --porcelain=v2 --branch")
//     if (output === null) return null
//     const lines = output.split("\n")
//     const result = {
//       branch: "",
//       upstream: null as string | null,
//       ahead: 0,
//       behind: 0,
//       staged: [] as string[],
//       unstaged: [] as string[],
//       untracked: [] as string[],
//       conflicts: [] as string[],
//     }
//     for (const line of lines) {
//       if (line.startsWith("# branch.head ")) {
//         result.branch = line.slice(14)
//       } else if (line.startsWith("# branch.upstream ")) {
//         result.upstream = line.slice(18)
//       } else if (line.startsWith("# branch.ab ")) {
//         const match = line.match(/\+(\d+) -(\d+)/)
//         if (match) {
//           result.ahead = parseInt(match[1], 10)
//           result.behind = parseInt(match[2], 10)
//         }
//       } else if (line.startsWith("1 ") || line.startsWith("2 ")) {
//         const xy = line.slice(2, 4)
//         const path = line.split("\t").pop() || line.split(" ").pop() || ""
//         if (xy[0] !== ".") result.staged.push(path)
//         if (xy[1] !== ".") result.unstaged.push(path)
//       } else if (line.startsWith("u ")) {
//         const path = line.split("\t").pop() || ""
//         result.conflicts.push(path)
//       } else if (line.startsWith("? ")) {
//         result.untracked.push(line.slice(2))
//       }
//     }
//     return result
//   },
// })

// export const isClean = tool({
//   description: "Check if working tree is clean (no uncommitted changes).",
//   args: {},
//   async execute() {
//     const output = gitSafe("status --porcelain")
//     if (output === null) return null
//     return output === ""
//   },
// })

// export const getConflictedFiles = tool({
//   description: "List files with merge conflicts.",
//   args: {},
//   async execute() {
//     const output = gitSafe("diff --name-only --diff-filter=U")
//     return output ? output.split("\n").filter(Boolean) : []
//   },
// })

// // =============================================================================
// // Branch Operations
// // =============================================================================

// export const checkout = tool({
//   description: "Checkout a branch and optionally update submodules.",
//   args: {
//     branch: tool.schema.string().describe("Branch name to checkout"),
//     updateSubmodules: tool.schema.boolean().optional().describe("Run submodule update after checkout (default: true)"),
//   },
//   async execute(args) {
//     const updateSubmodules = args.updateSubmodules ?? true
//     const validatedBranch = validateBranchName(args.branch)
//     if (!validatedBranch) return { error: "Invalid branch name" }
//     if (gitSafe(`rev-parse --verify ${validatedBranch}`) === null) {
//       if (gitSafe(`rev-parse --verify origin/${validatedBranch}`) !== null) {
//         git(`checkout -b ${validatedBranch} origin/${validatedBranch}`)
//       } else {
//         return { error: `Branch '${validatedBranch}' does not exist locally or on origin` }
//       }
//     } else {
//       git(`checkout ${validatedBranch}`)
//     }
//     if (updateSubmodules) {
//       gitSafe("submodule update --init --recursive")
//     }
//     return { success: true, message: `Checked out '${validatedBranch}'` }
//   },
// })

// export const createBranch = tool({
//   description: "Create a new branch from a base branch and switch to it.",
//   args: {
//     name: tool.schema.string().describe("New branch name"),
//     baseBranch: tool.schema.string().optional().describe("Base branch to branch from (default: 'main')"),
//     updateSubmodules: tool.schema.boolean().optional().describe("Run submodule update after creation (default: true)"),
//   },
//   async execute(args) {
//     const baseBranchInput = args.baseBranch ?? "main"
//     const updateSubmodules = args.updateSubmodules ?? true
//     const validatedName = validateBranchName(args.name)
//     if (!validatedName) return { error: "Invalid branch name" }
//     const validatedBase = validateBranchName(baseBranchInput)
//     if (!validatedBase) return { error: "Invalid base branch name" }
//     if (gitSafe(`rev-parse --verify ${validatedName}`) !== null) {
//       return { error: `Branch '${validatedName}' already exists` }
//     }
//     let actualBase = validatedBase
//     if (gitSafe(`rev-parse --verify ${validatedBase}`) === null) {
//       if (gitSafe(`rev-parse --verify origin/${validatedBase}`) !== null) {
//         actualBase = `origin/${validatedBase}`
//       } else {
//         return { error: `Base branch '${validatedBase}' does not exist` }
//       }
//     }
//     git(`checkout -b ${validatedName} ${actualBase}`)
//     if (updateSubmodules) {
//       gitSafe("submodule update --init --recursive")
//     }
//     return { success: true, message: `Created and switched to branch '${validatedName}' from '${actualBase}'` }
//   },
// })

// export const deleteBranch = tool({
//   description: "Delete a local branch. Only allows deletion of fully merged branches.",
//   args: {
//     branch: tool.schema.string().describe("Branch name to delete"),
//   },
//   async execute(args) {
//     const validatedBranch = validateBranchName(args.branch)
//     if (!validatedBranch) return { error: "Invalid branch name" }
//     const currentBranch = gitSafe("rev-parse --abbrev-ref HEAD")
//     if (currentBranch === validatedBranch) {
//       return { error: "Cannot delete the currently checked out branch" }
//     }
//     if (gitSafe(`rev-parse --verify ${validatedBranch}`) === null) {
//       return { error: `Branch '${validatedBranch}' does not exist` }
//     }
//     const result = gitSafe(`branch -d ${validatedBranch}`)
//     if (result === null) {
//       return { error: `Branch '${validatedBranch}' is not fully merged. Merge it first or delete manually via shell.` }
//     }
//     return { success: true, message: `Deleted local branch '${validatedBranch}'` }
//   },
// })

// // =============================================================================
// // Staging & Committing
// // =============================================================================

// export const stageFiles = tool({
//   description: "Stage files for commit. Use ['.'] to stage all changes.",
//   args: {
//     files: tool.schema.array(tool.schema.string()).describe("File paths to stage (use ['.'] for all)"),
//   },
//   async execute(args) {
//     const files = args.files
//     if (!files || files.length === 0) return { error: "No files specified" }
//     const validatedFiles = files[0] === "." && files.length === 1 ? ["."] : validateFilePaths(files)
//     if (!validatedFiles || validatedFiles.length === 0) {
//       return { error: "Invalid file paths" }
//     }
//     const escapedFiles = validatedFiles.map(escapeForShell).join(" ")
//     const result = gitSafe(`add -- ${escapedFiles}`)
//     if (result === null) return { error: "Failed to stage files" }
//     return { success: true, message: `Staged ${files[0] === "." ? "all changes" : validatedFiles.join(", ")}` }
//   },
// })

// export const unstageFiles = tool({
//   description: "Unstage files (remove from staging area, keep changes in working tree).",
//   args: {
//     files: tool.schema.array(tool.schema.string()).describe("File paths to unstage"),
//   },
//   async execute(args) {
//     const files = args.files
//     if (!files || files.length === 0) return { error: "No files specified" }
//     const validatedFiles = validateFilePaths(files)
//     if (!validatedFiles || validatedFiles.length === 0) {
//       return { error: "Invalid file paths" }
//     }
//     const escapedFiles = validatedFiles.map(escapeForShell).join(" ")
//     const result = gitSafe(`restore --staged -- ${escapedFiles}`)
//     if (result === null) return { error: "Failed to unstage files" }
//     return { success: true, message: `Unstaged ${validatedFiles.join(", ")}` }
//   },
// })

// export const commit = tool({
//   description: "Create a commit with staged changes.",
//   args: {
//     message: tool.schema.string().describe("Commit message"),
//     files: tool.schema.array(tool.schema.string()).optional().describe("Files to stage before committing (optional)"),
//   },
//   async execute(args) {
//     const message = args.message
//     const files = args.files
//     if (!message || message.trim() === "") return { error: "Commit message cannot be empty" }
//     if (files && files.length > 0) {
//       const validatedFiles = files[0] === "." && files.length === 1 ? ["."] : validateFilePaths(files)
//       if (!validatedFiles || validatedFiles.length === 0) {
//         return { error: "Invalid file paths" }
//       }
//       const escapedFiles = validatedFiles.map(escapeForShell).join(" ")
//       gitSafe(`add -- ${escapedFiles}`)
//     }
//     const escapedMessage = message.replace(/'/g, "'\\''")
//     const result = gitSafe(`commit -m '${escapedMessage}'`)
//     if (result === null) return { error: "Commit failed. Are there staged changes?" }
//     return { success: true, message: `Committed: ${message}` }
//   },
// })

// export const amendCommit = tool({
//   description: "Amend the last commit. Can change message and/or add staged files to it.",
//   args: {
//     message: tool.schema.string().optional().describe("New commit message (omit to keep existing)"),
//   },
//   async execute(args) {
//     const message = args.message
//     let cmd = "commit --amend"
//     if (message) {
//       const escapedMessage = message.replace(/'/g, "'\\''")
//       cmd += ` -m '${escapedMessage}'`
//     } else {
//       cmd += " --no-edit"
//     }
//     const result = gitSafe(cmd)
//     if (result === null) return { error: "Amend failed" }
//     return { success: true, message: message ? `Amended commit with new message: ${message}` : "Amended commit with staged changes" }
//   },
// })

// export const undoLastCommit = tool({
//   description: "Undo the last commit, keeping changes staged.",
//   args: {},
//   async execute() {
//     const logCheck = gitSafe("rev-parse HEAD")
//     if (logCheck === null) return { error: "No commits to undo" }
//     const result = gitSafe("reset --soft HEAD~1")
//     if (result === null) return { error: "Failed to undo last commit" }
//     return { success: true, message: "Undid last commit (changes kept staged)" }
//   },
// })

// // =============================================================================
// // Stash
// // =============================================================================

// export const stash = tool({
//   description: "Stash current changes.",
//   args: {
//     message: tool.schema.string().optional().describe("Description for the stash"),
//     includeUntracked: tool.schema.boolean().optional().describe("Include untracked files (default: false)"),
//   },
//   async execute(args) {
//     const message = args.message
//     const includeUntracked = args.includeUntracked ?? false
//     const status = gitSafe("status --porcelain")
//     if (status === null) return { error: "Not in a git repository" }
//     if (status === "") return { error: "Nothing to stash - working tree is clean" }
//     let cmd = "stash push"
//     if (includeUntracked) cmd += " -u"
//     if (message) {
//       const escapedMsg = message.replace(/'/g, "'\\''")
//       cmd += ` -m '${escapedMsg}'`
//     }
//     const result = gitSafe(cmd)
//     if (result === null) return { error: "Failed to stash changes" }
//     return { success: true, message: `Stashed changes${message ? `: ${message}` : ""}` }
//   },
// })

// export const stashPop = tool({
//   description: "Apply and remove the most recent stash (or specified stash).",
//   args: {
//     index: tool.schema.number().optional().describe("Stash index to pop (default: 0, most recent)"),
//   },
//   async execute(args) {
//     const index = args.index ?? 0
//     if (typeof index !== "number" || index < 0 || !Number.isInteger(index)) {
//       return { error: "Invalid stash index" }
//     }
//     const listOutput = gitSafe("stash list")
//     if (!listOutput) return { error: "No stashes found" }
//     const stashCount = listOutput.split("\n").filter(Boolean).length
//     if (index >= stashCount) {
//       return { error: `Stash @{${index}} does not exist. Only ${stashCount} stash(es) available.` }
//     }
//     const result = gitSafe(`stash pop stash@{${index}}`)
//     if (result === null) return { error: `Failed to pop stash@{${index}}. May have conflicts.` }
//     return { success: true, message: `Applied and removed stash@{${index}}` }
//   },
// })

// export const listStashes = tool({
//   description: "List all stashes.",
//   args: {},
//   async execute() {
//     const output = gitSafe("stash list")
//     if (!output) return []
//     return output.split("\n").filter(Boolean).map((line, idx) => {
//       const match = line.match(/^stash@\{(\d+)\}: (?:On|WIP on) ([^:]+): (.*)$/)
//       if (match) {
//         return { index: parseInt(match[1], 10), branch: match[2], message: match[3] }
//       }
//       return { index: idx, branch: "unknown", message: line }
//     })
//   },
// })

// // =============================================================================
// // Remote Operations
// // =============================================================================

// export const fetch = tool({
//   description: "Fetch updates from remote and prune deleted branches.",
//   args: {
//     remote: tool.schema.string().optional().describe("Remote name (default: 'origin')"),
//     all: tool.schema.boolean().optional().describe("Fetch all remotes (default: false)"),
//   },
//   async execute(args) {
//     const remote = args.remote ?? "origin"
//     const all = args.all ?? false
//     if (!all) {
//       const validatedRemote = validateBranchName(remote)
//       if (!validatedRemote) return { error: "Invalid remote name" }
//       const remotes = gitSafe("remote")
//       if (!remotes || !remotes.split("\n").includes(validatedRemote)) {
//         return { error: `Remote '${validatedRemote}' does not exist` }
//       }
//       const result = gitSafe(`fetch ${validatedRemote} --prune`)
//       if (result === null) return { error: `Failed to fetch from '${validatedRemote}'` }
//       return { success: true, message: `Fetched from '${validatedRemote}' and pruned` }
//     }
//     const result = gitSafe("fetch --all --prune")
//     if (result === null) return { error: "Failed to fetch from remotes" }
//     return { success: true, message: "Fetched all remotes and pruned" }
//   },
// })

// export const pull = tool({
//   description: "Pull changes from remote. Uses fast-forward only by default (safe).",
//   args: {
//     remote: tool.schema.string().optional().describe("Remote name (default: 'origin')"),
//     branch: tool.schema.string().optional().describe("Branch name (default: current branch)"),
//     ffOnly: tool.schema.boolean().optional().describe("Fast-forward only, fail if not possible (default: true)"),
//   },
//   async execute(args) {
//     const remote = args.remote ?? "origin"
//     const branch = args.branch
//     const ffOnly = args.ffOnly ?? true
//     const validatedRemote = validateBranchName(remote)
//     if (!validatedRemote) return { error: "Invalid remote name" }
//     const remotes = gitSafe("remote")
//     if (!remotes || !remotes.split("\n").includes(validatedRemote)) {
//       return { error: `Remote '${validatedRemote}' does not exist` }
//     }
//     let cmd = "pull"
//     if (ffOnly) cmd += " --ff-only"
//     cmd += ` ${validatedRemote}`
//     if (branch) {
//       const validatedBranch = validateBranchName(branch)
//       if (!validatedBranch) return { error: "Invalid branch name" }
//       cmd += ` ${validatedBranch}`
//     }
//     const result = gitSafe(cmd)
//     if (result === null) {
//       if (ffOnly) return { error: "Pull failed. Fast-forward not possible - local has diverged. Consider rebase or merge." }
//       return { error: "Pull failed" }
//     }
//     return { success: true, message: `Pulled from '${validatedRemote}'${branch ? `/${branch}` : ""}` }
//   },
// })

// export const push = tool({
//   description: "Push current branch to remote. Sets upstream if not configured.",
//   args: {
//     remote: tool.schema.string().optional().describe("Remote name (default: 'origin')"),
//     setUpstream: tool.schema.boolean().optional().describe("Set upstream tracking (default: true)"),
//   },
//   async execute(args) {
//     const remote = args.remote ?? "origin"
//     const setUpstream = args.setUpstream ?? true
//     const validatedRemote = validateBranchName(remote)
//     if (!validatedRemote) return { error: "Invalid remote name" }
//     const remotes = gitSafe("remote")
//     if (!remotes || !remotes.split("\n").includes(validatedRemote)) {
//       return { error: `Remote '${validatedRemote}' does not exist` }
//     }
//     const currentBranch = gitSafe("rev-parse --abbrev-ref HEAD")
//     if (!currentBranch || currentBranch === "HEAD") {
//       return { error: "Cannot push: in detached HEAD state or not in a git repo" }
//     }
//     let cmd = "push"
//     if (setUpstream) cmd += " --set-upstream"
//     cmd += ` ${validatedRemote} ${currentBranch}`
//     const result = gitSafe(cmd)
//     if (result === null) return { error: `Failed to push '${currentBranch}' to '${validatedRemote}'` }
//     return { success: true, message: `Pushed '${currentBranch}' to '${validatedRemote}'` }
//   },
// })

// // =============================================================================
// // Merge & Rebase
// // =============================================================================

// export const merge = tool({
//   description: "Merge a branch into the current branch.",
//   args: {
//     branch: tool.schema.string().describe("Branch to merge"),
//     noFf: tool.schema.boolean().optional().describe("Create merge commit even if fast-forward possible (default: false)"),
//   },
//   async execute(args) {
//     const noFf = args.noFf ?? false
//     const validatedBranch = validateBranchName(args.branch)
//     if (!validatedBranch) return { error: "Invalid branch name" }
//     if (gitSafe(`rev-parse --verify ${validatedBranch}`) === null) {
//       return { error: `Branch '${validatedBranch}' does not exist` }
//     }
//     let cmd = "merge"
//     if (noFf) cmd += " --no-ff"
//     cmd += ` ${validatedBranch}`
//     const result = gitSafe(cmd)
//     if (result === null) {
//       const conflicts = gitSafe("diff --name-only --diff-filter=U")
//       if (conflicts) {
//         return { error: "Merge has conflicts", conflicts: conflicts.split("\n").filter(Boolean) }
//       }
//       return { error: "Merge failed" }
//     }
//     return { success: true, message: `Merged '${validatedBranch}' into current branch` }
//   },
// })

// export const abortMerge = tool({
//   description: "Abort an in-progress merge and restore pre-merge state.",
//   args: {},
//   async execute() {
//     const merging = gitSafe("rev-parse -q --verify MERGE_HEAD")
//     if (merging === null) return { error: "No merge in progress" }
//     const result = gitSafe("merge --abort")
//     if (result === null) return { error: "Failed to abort merge" }
//     return { success: true, message: "Merge aborted" }
//   },
// })

// export const abortRebase = tool({
//   description: "Abort an in-progress rebase and restore original branch state.",
//   args: {},
//   async execute() {
//     const result = gitSafe("rebase --abort")
//     if (result === null) return { error: "No rebase in progress or failed to abort" }
//     return { success: true, message: "Rebase aborted" }
//   },
// })

// export const continueRebase = tool({
//   description: "Continue a paused rebase after resolving conflicts.",
//   args: {},
//   async execute() {
//     const result = gitSafe("rebase --continue")
//     if (result === null) {
//       const conflicts = gitSafe("diff --name-only --diff-filter=U")
//       if (conflicts) {
//         return { error: "Cannot continue rebase - unresolved conflicts remain", conflicts: conflicts.split("\n").filter(Boolean) }
//       }
//       return { error: "Failed to continue rebase" }
//     }
//     return { success: true, message: "Rebase continued" }
//   },
// })

// // =============================================================================
// // Diff & Log
// // =============================================================================

// export const getDiff = tool({
//   description: "Get diff of changes.",
//   args: {
//     staged: tool.schema.boolean().optional().describe("Show staged changes only (default: false, shows unstaged)"),
//     file: tool.schema.string().optional().describe("Specific file to diff (optional)"),
//   },
//   async execute(args) {
//     const staged = args.staged ?? false
//     const file = args.file
//     let cmd = "diff"
//     if (staged) cmd += " --cached"
//     if (file) {
//       const validatedFiles = validateFilePaths([file])
//       if (!validatedFiles) return { error: "Invalid file path" }
//       cmd += ` -- ${escapeForShell(validatedFiles[0])}`
//     }
//     const result = gitSafe(cmd)
//     return result ?? ""
//   },
// })

// export const getLog = tool({
//   description: "Get commit log.",
//   args: {
//     limit: tool.schema.number().optional().describe("Number of commits (default: 10)"),
//     oneline: tool.schema.boolean().optional().describe("Short format (default: false)"),
//   },
//   async execute(args) {
//     let limit = args.limit ?? 10
//     const oneline = args.oneline ?? false
//     if (typeof limit !== "number" || limit < 1) limit = 10
//     if (limit > 500) limit = 500
//     if (oneline) {
//       const output = gitSafe(`log --oneline -n ${limit}`)
//       if (!output) return []
//       return output.split("\n").filter(Boolean).map(line => {
//         const spaceIdx = line.indexOf(" ")
//         if (spaceIdx === -1) return { hash: line, message: "" }
//         return { hash: line.slice(0, spaceIdx), message: line.slice(spaceIdx + 1) }
//       })
//     }
//     const output = gitSafe(`log --format="%H%x00%an%x00%ai%x00%s" -n ${limit}`)
//     if (!output) return []
//     return output.split("\n").filter(Boolean).map(line => {
//       const parts = line.split("\0")
//       if (parts.length < 4) {
//         return { hash: parts[0] || "", author: "", date: "", message: line }
//       }
//       return { hash: parts[0], author: parts[1], date: parts[2], message: parts[3] }
//     })
//   },
// })

