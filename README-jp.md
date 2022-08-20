# new-commit シェルスクリプト (.commit フォルダー)

## 概要

`new-commit` コマンドは、
Git の ワーキング ディレクトリ（.git フォルダーがあるフォルダー）の外でも
Git の ワーキング ディレクトリ のサブフォルダーでも使える
`git status` や `git diff` に相当するコマンドです。

```mermaid
graph LR;
    s[ リポジトリの中のコミット ] -- git diff --> d[ Git の ワーキング ディレクトリ の外にあるフォルダー];
```

または

```mermaid
graph LR;
    s[ リポジトリの中のフォルダー ] -- git diff --> d[ 同じリポジトリの中の別のフォルダー ];
```


## 動作

最初は、カレント フォルダー およびそのサブフォルダーにあるファイルを
カレント フォルダー の直下の `.commit` フォルダー にコピーします。
このとき、`.gitignore` に指定したファイルはコピーされません。
この `.commit` フォルダーが、`git status` や `git diff` の比較対象に相当します。

```mermaid
graph LR;
    s[ カレント フォルダー ];
    d[ .commit フォルダー ];
    s -. .gitignore を踏まえたコピー .-> d;
```

次に、カレント フォルダー の直下に `.commit` フォルダー が存在している場合、
カレント フォルダー およびそのサブフォルダーにあるファイルを
カレント フォルダー の直下の `.commit_new` フォルダー にコピーします。
そしてすぐに、`.commit` フォルダーと違いがあるファイル名を一覧します。
この動作が、`git status` や `git diff` に相当します。

```mermaid
flowchart TD;
    s[ カレント フォルダー ];
    subgraph &nbsp;
        c[ .commit フォルダー ];
        d[ .commit_new フォルダー ];
    end
    s -. .gitignore を踏まえたコピー .-> d;
    c <-- 比較 --> d;
```


## 動作環境

- Windows (bash)
- mac
- Linux


## インストール

- 動作には Git のインストールが必要です。
    bash や zsh から git コマンドが使えるようにしてください。
- `bin` フォルダーにある `new-commit` ファイルを
    bash のパスの通ったフォルダーにコピーしてください。


## 使い方

`new-commit` コマンドは、パラメーターを指定しません。
状況に応じて動きが変わります。

なお、`.gitignore` ファイルには、`.commit` フォルダーや
`.commit_new` フォルダーを指定するべきです。

`.gitignore` のサンプル:

    .commit
    .commit_new

### `.commit` フォルダーが無い場合

カレント フォルダー の直下に `.commit` フォルダーが無い場合、
カレント フォルダー およびそのサブフォルダーにあるファイルを
カレント フォルダー の直下の `.commit` フォルダー にコピーします。
このとき、`.gitignore` に指定したファイルはコピーされません。
この `.commit` フォルダーが、`git status` や `git diff` の比較対象に相当します。

- `.commit` フォルダー は `.gitignore` に指定されているので、
    コミットの追加やブランチの変更などを行っても
    `git status` や `git diff` の比較対象に相当する内容は変化しません
- `.commit` フォルダー は任意のフォルダーに移動することができます
- git でステージングされていない変更も `.commit` フォルダーに入ります

コマンドの例:

    $ cd __WorkFolder__
    $ new-commit
    Created new ".commit" folder.
    This will be treated as base commit.
    $ ls .commit
    .gitignore
    package.json

### `.commit` フォルダーがすでに有る場合

カレント フォルダー の直下に `.commit` フォルダーがすでに有る場合、
カレント フォルダー およびそのサブフォルダーにあるファイルを
カレント フォルダー の直下の `.commit_new` フォルダー にコピーします。
このとき、`.gitignore` に指定したファイルはコピーされません。
そしてすぐに、`.commit` フォルダーと違いがあるファイル名を一覧します。
この動作が、`git status` や `git diff` に相当します。

- 異なるファイルに関する表示内容は、`diff -qr` コマンドと同じです
- git でステージングされていない変更も `.commit_new` フォルダーに入ります

コマンドの例:

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

もし、`.commit` フォルダーの内容と `.commit_new` フォルダーの内容が
同じ場合、すぐに `.commit_new` フォルダーが削除されます。

    $ cd __Project__
    $ new-commit
    Deleted ".commit_new" folder.
    SAME as ".commit" folder.
