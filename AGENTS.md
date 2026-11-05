# Project Versioning, Watermark & Git Commit Rules

Follow these rules whenever making any code, scene, asset, or configuration alteration in this repository:

1. **Increment Project Version & Watermark Before Committing**:
   - Before creating a commit for any alteration, increment the minor integer part of the version string `0.<N>` to `0.<N+1>` (for example: `0.5` -> `0.6`, `0.9` -> `0.10`, `0.99` -> `0.100`). Never roll over the major version to `1.0` automatically.
   - Update the version across all three locations so the in-game watermark and project metadata stay synchronized:
     - `scripts/global.gd`: Update `const GAME_VERSION: String = "<version>";` (drives the `pre-alpha <version>` watermark label).
     - `project.godot`: Update `config/version="<version>"` under `[application]`.
     - `README.md`: Update `> **Status**: \`pre-alpha <version>\``.

2. **Automatic Local Commit for Rollback Safety**:
   - Stage and create a local Git commit after completing each alteration so the project always has a clean rollback point.
   - Format the commit message following the repository's standard:
     `<version> <concise lowercase summary of changes>`
     *(Example: `0.5 resolution options, fullscreen mode, and responsive UI scaling`)*

3. **Never Push Without Explicit Approval**:
   - **Never** run `git push` automatically.
   - Only push to the remote repository when the user explicitly asks to push.
