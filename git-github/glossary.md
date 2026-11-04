# 📖 Git & GitHub Glossary

*The key Git and GitHub terms from the deck, explained for someone who has never used either. Throughout, picture one simple scenario: your project is a **folder of files on your laptop** (a report, some code, some notes), and the **cloud** is an online copy of that folder on GitHub that backs it up and lets others see it.*

---

## 1. The big picture

**Version control**
A tool that saves the full history of your folder, so you can see every past version and return to any of them. *For example, it is like an unlimited "undo" for your whole project, not just for one file.*

**Git**
The free tool that runs on your laptop and does the version control. It quietly records a history of your folder as you work. *For example, once Git is watching your project folder, it remembers every version you save.*

**GitHub**
A website that stores a copy of your Git folder in the cloud, so it is backed up and other people can see it. *For example, you put your folder on GitHub so a teammate can open it from their own computer.*

**Repository (repo)**
A folder that Git is tracking, including its full history. Your repo is your project plus its memory. *For example, your `thesis-analysis` folder becomes a repository the moment Git starts watching it.*

**Distributed**
Every copy of a repo holds the complete history, not just the latest files, so no single computer is the one everyone depends on. *For example, your laptop and GitHub each hold the entire history, so if one is lost, the project is not.*

**History (commit history)**
The ordered chain of all your commits, each linked to the one before it, from your first save to your latest. It is what `git log` shows and what version control actually keeps. *For example, your current files are only the latest snapshot, while the history is every snapshot behind it, so a file you delete today still lives on in yesterday's commit.*

---

## 2. Where your code lives (the four places)

**Working Directory**
The live folder on your laptop where you actually open and edit files. *For example, the files you can see and change in your editor right now.*

**Staging Area**
A holding area where you line up exactly which changes go into your next saved version. *For example, you edited five files but stage only the two that are finished.*

**Local Repository**
The hidden history (a folder named `.git`) on your laptop that stores every version you have saved. *For example, even after you delete an old file, the local repository still remembers it.*

**Remote Repository**
The copy of your repo that lives in the cloud on GitHub, shared and backed up. *For example, you and a teammate both sync with the same remote repository.*

**Commit**
One saved version of your whole folder, with a short note describing it. Think of it as a photo of your project at one moment. *For example, saving with the note "Add results chart" gives you a version you can return to anytime.*

**Snapshot**
Another word for what a commit saves: a complete picture of your folder at that moment. *For example, each commit is a snapshot you can rewind to later.*

---

## 3. Setting up and saving (the daily loop)

**git config**
A one-time setup that tells Git your name and email, so your saves are signed by you. *For example, you set your name once, and every version you save is stamped with it.*

**git init**
Turns a normal folder into a Git repository, so Git starts tracking it. *For example, you run it inside your project folder to begin keeping a history.*

**git clone**
Downloads a full copy of an existing repo, with all its history, from GitHub to your laptop. *For example, you clone your professor's starter project so you can build on it.*

**.gitignore**
A small text file listing things Git should never track or upload, such as passwords or huge folders. *For example, you add `.env` to it so your secret keys never reach the cloud.*

**git status**
Shows what has changed in your folder since your last save. *For example, you run it before saving to see which files are new or edited.*

**git add**
Moves your chosen changes into the staging area, ready to be saved. *For example, you stage just `report.md` because the other files are not finished.*

**git commit**
Saves the staged changes as a new version (a commit) in your local history. *For example, you commit your finished section with a clear note about what changed.*

**git log**
Lists your past commits, so you can scroll back through your project's history. *For example, you use it to find the version you had last Tuesday.*

---

## 4. Syncing with the cloud

**git push**
Uploads your saved versions from your laptop up to GitHub. *For example, you push at the end of the day so your work is safely backed up online.*

**git fetch**
Downloads new versions from GitHub into your local history, but does not change the files you are editing. *For example, you fetch to peek at a teammate's update before you actually use it.*

**git pull**
Downloads new versions from GitHub and merges them straight into your files. It is a fetch plus a merge in one step. *For example, you pull in the morning to get everyone's latest work.*

**origin**
The default nickname for your repo's copy on GitHub. *For example, "push to origin main" means send your work to origin, the main version.*

**main**
The default name for the primary, trustworthy version of your project. Older projects call it `master`. *For example, you keep `main` clean and working at all times.*

---

## 5. Branching and teamwork

**Branch**
A separate copy of your project where you can try things without touching `main`. *For example, you make a branch to test a risky idea, and delete it if it does not work out.*

**git checkout**
Switches which branch or version you are currently working on. *For example, "checkout main" takes you back to the main version of the project.*

**git merge**
Combines the work from one branch into another. *For example, you merge your finished experiment branch back into `main`.*

**Merge conflict**
When two changes touch the same line and Git cannot decide which to keep, so it stops and asks you. *For example, you and a teammate both edited the same title, and Git asks which version wins.*

**Pull Request (PR)**
A request on GitHub to merge your branch in, where others review it first. It is a button on the website, not a command. *For example, you open a PR so your advisor checks your work before it joins `main`.*

**Merge Request**
The same thing as a Pull Request, just the name GitLab uses for it. *For example, on GitLab you "open a Merge Request" instead of a Pull Request.*

**Fork**
Your own copy of someone else's GitHub repo, so you can change it and suggest improvements back. *For example, you fork an open-source project, fix a bug, and send a Pull Request to the original.*

**Rebase**
An advanced cleanup that rewrites your project's history into one neat, straight line. *For example, it is a polish step, safe to skip until the basics feel solid.*

---

## 6. Undo and safety nets

**git restore**
Throws away unsaved edits and returns a file to your last saved version. *For example, the file is a mess, so you restore it to how it was at your last commit.*

**git reset**
Rewinds your branch to an earlier commit. Use it only on your own local work, because it deletes the commits after that point. *For example, a recent commit broke things, so you reset back to a working one.*

**git revert**
Safely undoes a commit by adding a new commit that cancels it, without erasing history. *For example, a bad change is already on GitHub, so you revert it so the team's copies stay safe.*

**git stash**
Sets your half-finished work aside so you can switch tasks, then brings it back later. *For example, you stash your edits, fix an urgent bug, then pop the stash to continue where you left off.*

---

## 7. Setup, security, and scaling

**SSH key**
A one-time secure handshake between your laptop and GitHub, so you can push and pull without typing a password each time. *For example, you set up an SSH key once, then sync freely forever after.*

**Personal access token**
A password-like code for connecting to GitHub over HTTPS, an alternative to an SSH key. *For example, you paste a token instead of your account password when Git asks for one.*

**Monorepo**
Keeping everything, all parts of a project, in one single repository. Simple for small teams. *For example, your whole app, both front and back, lives in one repo.*

**Polyrepo**
Splitting a project across many separate repositories. Common at larger scale. *For example, a big company keeps each service in its own repo.*

---

## 8. Big files and storage limits

**Binary file**
A file that is not plain text, such as a PDF, an image, or a dataset. Git still saves every version, but it cannot show what changed inside one, and many versions make the repo big. *For example, each time you save your report PDF, Git keeps another full copy of it.*

**File / repo size limit**
GitHub blocks any single file larger than 100 MB, and recommends keeping a whole repo under about 1 GB. *For example, a 200 MB data file is refused, so you keep it out of the repo or use Git LFS.*

**Git LFS (Large File Storage)**
An add-on for big files you must keep. It stores a tiny pointer in Git and the real file in a separate place, free up to 1 GB. *For example, you track your large dataset with Git LFS, so cloning the repo stays fast.*

---

*Need the story behind these words? See [story.md](./story.md) for the same ideas told as one continuous tale.*
