# new-commit shell script (.commit folder)

## Overview

The `new-commit` command is the equivalent of `git status` and `git diff`
that can be used outside the Git working directory
(the folder containing the .git folder)
or in subfolders of the Git working directory.

```mermaid
graph LR;
    s[ A commit in a reposiroty ] -- git diff --> d[ A folder outside of Git working directory ];
```

or

```mermaid
graph LR;
    s[ A folder in a repository ] -- git diff --> d[ Another folder in the same reposiroty ];
```


## Behavior

First, `new-commit` command copies the files in the current folder
and its subfolders to the `.commit` folder directly under the current folder.
At this time, files specified in `.gitignore` are not copied.
This `.commit` folder is as the comparison target of `git status` and `git diff`.

```mermaid
graph LR;
    s[ Current folder ];
    d[ .commit folder ];
    s -. Copy using .gitignore .-> d;
```

Next, if the `.commit` folder exists directly under the current folder,
the files in the current folder and its subfolders are copied to
the `.commit_new` folder directly under the current folder.
And immediately lists file names that differ from the `.commit` folder.
This behavior corresponds to `git status` and `git diff`.

```mermaid
flowchart TD;
    s[ Current folder ];
    subgraph &nbsp;
        c[ .commit folder ];
        d[ .commit_new folder ];
    end
    s -. Copy using .gitignore .-> d;
    c <-- Compare --> d;
```

Files in `.commit` and `.commit_new` folders are read-only.


## Environment

- Windows (bash)
- mac
- Linux


## Install

- It requires Git installed to work.
    Make sure you can use git commands from bash or zsh.
- Copy the `new-commit` file in `bin` folder
    to a folder in your bash path.


## Usage

### new-commit command

`new-commit` command of copying using .gitignore
takes no parameters.
The movement changes depending on the situation.

The `.gitignore` file should write
to the `.commit` folders and `.commit_new` folders.

Sample `.gitignore`:

    .commit
    .commit_new

### Case of no `.commit` folder

If there is no `.commit` folder directly under the current folder,
copies the files in the current folder and its subfolders
to the `.commit` folder directly under the current folder.
At this time, files specified in `.gitignore` are not copied.
This `.commit` folder is the comparison target of `git status` and `git diff`.

- The `.commit` folder is specified in `.gitignore`,
    so even if you add a commit or change the branch,
    the contents corresponding to the comparison target of
    `git status` or `git diff` will not change.
- `.commit` folder can be moved to any folder
- Unstaged changes in git also copy into the `.commit` folder
- Files in `.commit` folders are turned on read-only attribute

Sample commands:

    $ cd __WorkFolder__
    $ new-commit
    Created new ".commit" folder.
    This will be treated as base commit.
    $ ls .commit
    .gitignore
    package.json

### Case that `.commit` folder is already exists

If there is already a `.commit` folder directly under the current folder,
copies the files in the current folder and its subfolders
to the `.commit_new` folder directly under the current folder.
At this time, files specified in `.gitignore` are not copied.
And immediately lists filenames that differ from the `.commit` folder.
This behavior corresponds to `git status` and `git diff`.

- The output for different files is the same as the `diff -qr` command
- Unstaged changes in git also copy into the `.commit_new` folder
- Files in `.commit_new` folders are turned on read-only attribute

Sample commands:

    $ cd __WorkFolder__
    $ new-commit
    Created new ".commit_new" folder.
    Changes for .commit:
        Files .commit/package.json and .commit_new/package.json differ
        Only in .commit_new: tsconfig.json
    $ ls .commit
    .gitignore
    package.json
    $ ls .commit_new
    .gitignore
    package.json
    tsconfig.json

If the contents of the `.commit` folder and the contents of
the `.commit_new` folder are the same,
the `.commit_new` folder will be deleted immediately.

    $ cd __Project__
    $ new-commit
    Deleted ".commit_new" folder.
    SAME as ".commit" folder.


## push command

    new-commit push __RepositoryFolderPath__

Push command copies files in `.commit_new` folder to `__RepositoryFolderPath__`
and turn off the read-only attribute of the file.
Also move files in the `.commit_new` folder into the `.commit` folder
and delete `.commit_new` folder.

Only if there is no difference between `.commit` and `.commit_new` folders
(only if `.commit_new` folder is not created),
copy files in `.commit` folder to the `__RepositoryFolderPath__` folder
and turn off the read-only attribute of the file.

- Replace `__RepositoryFolderPath__` to the actual folder path
- Files that there are in `__RepositoryFolderPath__` but not in `.commit_new` folder
    is deleted
- `.git` folder directly under `__RepositoryFolderPath__` is not changed
