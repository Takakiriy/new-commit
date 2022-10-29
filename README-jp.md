# new-commit シェルスクリプト (.commit フォルダー)

## 概要

`new-commit` コマンドは、
Git の ワーキング ディレクトリ（.git フォルダーがあるフォルダー）の外でも
Git の ワーキング ディレクトリ のサブフォルダーでも使える
`git status` や `git diff` に相当するコマンドです。

```mermaid
graph LR;
    s[ リポジトリの中のコミット ] -- git status or git diff --> d[ Git の ワーキング ディレクトリ の外にあるフォルダー];
```

または

```mermaid
graph LR;
    s[ リポジトリの中のフォルダー ] -- git status or git diff --> d[ 同じリポジトリの中の別のフォルダー ];
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

### new-commit コマンド

.gitignore を踏まえたコピーをするときの
`new-commit` コマンドは、パラメーターを指定しません。
状況に応じて動きが変わります。

なお、`.gitignore` ファイルには、`.commit` や
`.commit_*` を指定するべきです。

`.gitignore` のサンプル:

    .commit
    .commit_*

### `.commit` フォルダーが無い場合

カレント フォルダー の直下に `.commit` フォルダーが無い場合、
カレント フォルダー およびそのサブフォルダーにあるファイルを
カレント フォルダー の直下の `.commit` フォルダー にコピーします。
このとき、`.gitignore` に指定したファイルはコピーされません。
この `.commit` フォルダーが、`git status` や `git diff` の比較対象に相当します。

- Git でステージングされていない変更も `.commit` フォルダーに入ります
- `.commit` フォルダーの中のファイルは、読み取り専用になります
- Git の ワーキング フォルダー の外で `new-commit` コマンドを実行すると `.git` フォルダーも作られます。
  `.git` フォルダーが無いと `new-commit push` コマンドや `new-commit pull` コマンドが使えなくなります
- Git の ワーキング フォルダー のサブフォルダーで `new-commit` コマンドを実行すると `.git` フォルダーは作られませんが、
  `new-commit push` コマンドや `new-commit pull` コマンドは使えます
- `.commit` フォルダー は `.gitignore` に指定されているので、
    コミットの追加やブランチの変更などを行っても
    `git status` や `git diff` の比較対象に相当する内容は変化しません

コマンドの例:

    $ cd __WorkingDirectory__
    $ new-commit
    Added .git folder and first commit.
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
- 親の方向にある `.git` フォルダーに対する git コマンドでステージングされていない変更も
  `.commit_new` フォルダーに入ります
- `.commit_new` フォルダーの中のファイルは、読み取り専用になります

コマンドの例:

    $ cd __WorkingDirectory__
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

    $ cd __WorkingDirectory__
    $ new-commit
    Deleted ".commit_new" folder.
    SAME as ".commit" folder.


## --no-git オプション

`.git` フォルダーがあるフォルダーで `new-commit` コマンドを実行すると
エラーになりますが、`--no-git` オプションを付けるとエラーになりません。

- git でステージングされていない変更も `.commit` フォルダーに入ります
- `.commit` フォルダーの中のファイルは、読み取り専用になりません
- できた `.commit` フォルダー は任意のフォルダーに移動することができます
- `new-commit --no-git` コマンドを実行しても `.git` フォルダーの内容は変わりません
- `new-commit --no-git` コマンドを実行したフォルダーでは、
  `new-commit push` コマンドや `new-commit pull` コマンドは使えません

コマンドの例:

    $ cd __WorkingDirectory__
    $ new-commit --no-git
    Created new ".commit" folder.
    $ ls .commit
    .gitignore
    package.json


## pull コマンド

```mermaid
graph RL;
    r[ リポジトリの中のフォルダー ] -- git pull or git merge --> c[ カレント フォルダー ];
```

pull コマンドは、リポジトリ フォルダー の内容を カレント フォルダー に入力するマージをします。

    cd __WorkingDirectory__
    new-commit pull __RepositoryFolderPath__

pull コマンドを実行すると `__RepositoryFolderPath__` フォルダーの内容を 
カレント フォルダー にマージします。

    $ cd __WorkingDirectory__
    $ new-commit pull _repository
    Created ".commit_repository" folder
    Renamed ".commit_new" folder to ".commit_before_pull" folder
    Pull from ".commit_repository" folder
    Auto-merging example.txt
    Merge made by the 'ort' strategy.
    example.txt | 2 +-
    1 file changed, 1 insertion(+), 1 deletion(-)
        Files .commit/example.txt and .commit_repository/example.txt differ

最新の リポジトリ フォルダー の内容が `.commit` フォルダーの内容から変わっていたときは、
`.commit_before_pull` フォルダーと `.commit_repository` フォルダーが作られます。

- .commit_before_pull フォルダー: pull コマンドを実行する前の カレント フォルダー の内容
- .commit_repository フォルダー: 最新の リポジトリ フォルダー のコピー

push コマンドを使うと、通常の push コマンドの動作の他に、
`.commit_before_pull` フォルダーと
`.commit_repository` フォルダーの削除も行われます。

pull コマンドは、コンフリクトが起きることがあります。

    $ cd __WorkingDirectory__
    $ new-commit pull _repository
    Created ".commit_repository" folder
    Renamed ".commit_new" folder to ".commit_before_pull" folder
    Pull from ".commit_repository" folder
    Auto-merging example.txt
    CONFLICT (content): Merge conflict in example.txt
    Automatic merge failed; fix conflicts and then commit the result.
        Files .commit/example.txt and .commit_repository/example.txt differ

コンフリクトが解決するまで、new-commit コマンドは CONFLICT があることを表示します。

    $ cd __WorkingDirectory__
    $ new-commit
    Created new ".commit_new" folder.
    Changes for .commit:
        Files .commit/example.txt and .commit_new/example.txt differ
    CONFLICT:
        ./example.txt:3: <<<<<<< HEAD

解決したら push コマンドを使います。


## push コマンド

```mermaid
graph LR;
    c[ カレント フォルダー ] -- git push --> r[ リポジトリの中のフォルダー ];
```

push コマンドは、カレント フォルダー の内容を リポジトリ フォルダー に上書きコピーします。
もし、**push コマンドを実行するタイミングが pull コマンドの実行直後ではない場合、**
カレント フォルダー 以外の編集によって
リポジトリ フォルダー が更新された内容が、
push コマンドによって上書きされて無くなってしまうことに注意してください。

    cd __WorkingDirectory__
    new-commit push __RepositoryFolderPath__

push コマンドを実行すると `.commit_new` フォルダーの内容を `__RepositoryFolderPath__`
にコピーして、ファイルの読み取り専用属性をオフにします。
また、`.commit_new` フォルダーの内容を `.commit` フォルダーに移動して、
`.commit_new` フォルダーを削除します。

`.commit` フォルダーと `.commit_new` フォルダーに違いがない場合は
（`.commit_new` フォルダーが作られない場合は）、
`.commit` フォルダーの内容を `__RepositoryFolderPath__`
にコピーして、ファイルの読み取り専用属性をオフにします。

- `__RepositoryFolderPath__` は実際のフォルダーのパスに置き換えてください
- `__RepositoryFolderPath__` にあったファイルのうち、`.commit_new` フォルダーに無いファイルは
    削除されます
- `__RepositoryFolderPath__` の直下の `.git` フォルダーは、変化しません

`__RepositoryFolderPath__` に `/dev/null` を指定すると、コピーを行わず、
`.commit_new` フォルダーの内容を `.commit` フォルダーに移動して、
`.commit_new` フォルダーを削除します。
