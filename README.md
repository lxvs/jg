# Johnny's Git Kit

It adds several more convenient commands to Git Bash. Open Git Bash and use command `jg` for more details.

The term Johnny Git is come from `jg`, rather than otherwise.

`jg` was chosen as the prefix of all these commands because there is hardly any built-in command that initials with `jg`.

Besides, all these commands has the unique initial after `jg`.

Therefore, for example, you can simply type `jgc` and press <kbd>Tab</kbd> to get command `jgcommitnumber`.



## :hash: Commit Number

#### Synopsis

```bash
jgcommitnumber [<length> = 8]
```

#### Description

Copy the first `<length>` characters of commit number to clipboard.

`<length>` ranges from `1` to `40`, default `8`.



## :eyeglasses: Grep Commit

#### Synopsis

```bash
jggrepcommit [<option>] <pattern>
```

#### Description

Search for commits that meet the given regex pattern, and copy the first found commit number.

:warning: `\` itself needs another `\` to be escaped in Bash. E.g. if searching for `[`, pattern `\\[` should be used.

#### Options

Options are same with `grep`.

Try `grep --help` for more information.

| option                  | description                                                  |
| ----------------------- | ------------------------------------------------------------ |
| `-E, --extended-regexp` | `<pattern>` is an extended regular expression                |
| `-F, --fixed-strings`   | `<pattern>` is a set of newline-separated strings, i.e. disable regex |
| `-i, --ignore-case`     | ignore case distinctions                                     |



## :punch: Just Pull It

:warning: Uncommitted changes will be lost after execute it.

#### Synopsis

```bash
jgjustpullit <arg>
```

#### Description

HARD reset working tree and pull. In case of unintended discard of local changes, please add some argument to confirm the operation when there are local changes.

It is equivalent to

```bash
git reset --hard origin/HEAD
git pull
```

#### Options

when `<arg>` is `c` or `clean`, it will perform a `git clean -df` before the `reset` and `pull`.

If there was no argument provided, nothing would be done.



## :musical_note: Number for the History

#### Synopsis

```bash
jgnumberforthehistory
```

#### Description

Output a list of modified/added/removed files, with leading numbers before each line, `/` replaced by `\`, to the clipboard.

If there are staged changes, it will ignore the changes not staged. If there is no changes, it will compare with the 2nd last commit.

For example, you

* modified `some-folder/some-file` and `some-folder/another-file`
* added a new file `new-file`
* removed file `some-useless-file`

After execution of this `jgnumberforthehistory`, you will get

```
RelatedFiles:
Modified:
1. some-folder\another-file
2. some-folder\some-file
Added:
1. new-file
Removed:
1. some-useless-file
```

in your clipboard, and in file `~/NtmOutput.txt`.



## :e-mail: Push

#### Synopsis

```bash
jgpush [<branch> = master]
```

#### Description

Push local commits to Gerrit for review, equivalent to

```bash
git push origin HEAD:refs/for/<branch>
```



## :package: Stash

#### Synopsis

```bash
jgstash "<label>"
```

#### Description

Stash local changes with message: `<commit>  <label>` (two spaces between them), including untracked files, where `<commit>` means the short commit number (first 7 characters) of current HEAD.
