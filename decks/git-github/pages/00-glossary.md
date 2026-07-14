---
layout: section
---

<Eyebrow>Glossary</Eyebrow>

# The words you'll meet

A quick reference for the key Git and GitHub terms in this deck. Skim it now for a feel, and come back whenever a word is fuzzy. Throughout, picture your project as a folder of files on your laptop, with the cloud as an online copy.

---

# Glossary · the big picture

<div class="grid grid-cols-2 gap-x-8 gap-y-3 pt-4 text-sm">

<div><Chip tone="accent">Version control</Chip> A tool that saves your project's full history, so you can return to any past version.</div>

<div><Chip tone="accent">Git</Chip> The free tool on your laptop that does the version control.</div>

<div><Chip tone="accent">GitHub</Chip> A website that keeps a copy of your project in the cloud to back up and share it.</div>

<div><Chip tone="accent">Repository</Chip> A folder that Git tracks, including its full history. Also called a "repo".</div>

<div><Chip tone="accent">Distributed</Chip> Every copy holds the complete history, so there is no single point of failure.</div>

<div><Chip tone="accent">History</Chip> The ordered chain of all your commits, from your first save to your latest. Your current files are just the latest link; history is every link behind it.</div>

</div>

---

# Glossary · where your code lives

<div class="grid grid-cols-2 gap-x-8 gap-y-3 pt-4 text-sm">

<div><Chip tone="accent">Working Directory</Chip> The live folder on your laptop where you edit files.</div>

<div><Chip tone="accent">Staging Area</Chip> A holding area where you pick which changes go into the next save.</div>

<div><Chip tone="accent">Local Repository</Chip> The hidden <code>.git</code> history on your laptop that stores every saved version.</div>

<div><Chip tone="accent">Remote Repository</Chip> The shared copy of your repo in the cloud on GitHub.</div>

<div><Chip tone="accent">Commit</Chip> One saved version of your whole project, like a photo of it at that moment.</div>

<div><Chip tone="accent">Snapshot</Chip> Another word for what a commit saves, a full picture of your project.</div>

</div>

---

# Glossary · setting up and saving

<div class="grid grid-cols-2 gap-x-8 gap-y-3 pt-4 text-sm">

<div><Chip tone="accent">git config</Chip> One-time setup that signs your saves with your name and email.</div>

<div><Chip tone="accent">git init</Chip> Turns a normal folder into a Git repository.</div>

<div><Chip tone="accent">git clone</Chip> Downloads a full copy of an existing repo from GitHub.</div>

<div><Chip tone="accent">.gitignore</Chip> A file listing things Git should never track, like passwords.</div>

<div><Chip tone="accent">git status</Chip> Shows what has changed since your last save.</div>

<div><Chip tone="accent">git add</Chip> Moves chosen changes into the staging area.</div>

<div><Chip tone="accent">git commit</Chip> Saves the staged changes as a new version.</div>

<div><Chip tone="accent">git log</Chip> Lists your past commits, so you can scan your history.</div>

</div>

---

# Glossary · syncing with the cloud

<div class="grid grid-cols-2 gap-x-8 gap-y-3 pt-4 text-sm">

<div><Chip tone="accent">git push</Chip> Uploads your saved versions to GitHub.</div>

<div><Chip tone="accent">git fetch</Chip> Downloads updates into your history without changing your files.</div>

<div><Chip tone="accent">git pull</Chip> Downloads updates and merges them into your files. It is fetch plus merge.</div>

<div><Chip tone="accent">origin</Chip> The default nickname for your repo's copy on GitHub.</div>

<div><Chip tone="accent">main</Chip> The primary, trustworthy version of your project. Older projects call it <code>master</code>.</div>

</div>

---

# Glossary · branching and teamwork

<div class="grid grid-cols-2 gap-x-8 gap-y-3 pt-4 text-sm">

<div><Chip tone="accent">branch</Chip> A separate copy where you can try things without touching <code>main</code>.</div>

<div><Chip tone="accent">git checkout</Chip> Switches which branch or version you are working on.</div>

<div><Chip tone="accent">git merge</Chip> Combines one branch's work into another.</div>

<div><Chip tone="accent">merge conflict</Chip> When two changes touch the same line and Git asks you which to keep.</div>

<div><Chip tone="accent">Pull Request</Chip> A request on GitHub to merge your branch in, reviewed by others first.</div>

<div><Chip tone="accent">Merge Request</Chip> GitLab's name for a Pull Request.</div>

<div><Chip tone="accent">fork</Chip> Your own copy of someone else's repo, so you can improve it and suggest changes back.</div>

<div><Chip tone="accent">rebase</Chip> An advanced cleanup that rewrites history into one neat line. Safe to skip at first.</div>

</div>

---

# Glossary · undo and setup

<div class="grid grid-cols-2 gap-x-8 gap-y-3 pt-4 text-sm">

<div><Chip tone="accent">git restore</Chip> Throws away unsaved edits and returns a file to your last save.</div>

<div><Chip tone="accent">git reset</Chip> Rewinds your branch to an earlier commit. Local work only.</div>

<div><Chip tone="accent">git revert</Chip> Undoes a commit by adding a new one that cancels it, keeping history safe.</div>

<div><Chip tone="accent">git stash</Chip> Sets half-finished work aside, then brings it back later.</div>

<div><Chip tone="accent">SSH key</Chip> A one-time secure link so you push and pull without a password each time.</div>

<div><Chip tone="accent">Personal access token</Chip> A password-like code for connecting to GitHub over HTTPS.</div>

</div>

---

# Glossary · big files and storage

<div class="grid grid-cols-2 gap-x-8 gap-y-3 pt-4 text-sm">

<div><Chip tone="accent">monorepo</Chip> Keeping everything in one repository.</div>

<div><Chip tone="accent">polyrepo</Chip> Splitting a project across many repositories.</div>

<div><Chip tone="accent">binary file</Chip> A non-text file like a PDF, image, or dataset. Git saves each version in full but can't show what changed inside.</div>

<div><Chip tone="accent">File / repo size limit</Chip> GitHub blocks any file over 100 MB and suggests repos stay under about 1 GB.</div>

<div><Chip tone="accent">Git LFS</Chip> Stores a big file you must keep as a small pointer plus a separate file. Free up to 1 GB.</div>

</div>
