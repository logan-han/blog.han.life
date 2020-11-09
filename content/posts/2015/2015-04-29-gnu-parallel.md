---
title: "gnu parallel"
date: "2015-04-29"
---

So I was testing this today and this is the message I saw when I ran it:

`Academic tradition requires you to cite works you base your article on. When using programs that use GNU Parallel to process data for publication please cite:

O. Tange (2011): GNU Parallel - The Command-Line Power Tool, ;login: The USENIX Magazine, February 2011:42-47.

This helps funding further development; and it won't cost you a cent. If you pay 10000 EUR you should feel free to use GNU Parallel without citing.

To silence the citation notice: run 'parallel --bibtex'.`

Then, when I run it with --bibtex (odd enough already), it came up with: `Academic tradition requires you to cite works you base your article on. When using programs that use GNU Parallel to process data for publication please cite:

@article{Tange2011a, title = {GNU Parallel - The Command-Line Power Tool}, author = {O. Tange}, address = {Frederiksberg, Denmark}, journal = {;login: The USENIX Magazine}, month = {Feb}, number = {1}, volume = {36}, url = {http://www.gnu.org/s/parallel}, year = {2011}, pages = {42-47} doi = {10.5281/zenodo.16303} }

(Feel free to use \nocite{Tange2011a})

This helps funding further development; and it won't cost you a cent. If you pay 10000 EUR you should feel free to use GNU Parallel without citing.

If you send a copy of your published article to tange@gnu.org, it will be mentioned in the release notes of next version of GNU Parallel.

Type: 'will cite' and press enter.`

Totally made my day, no wonder it's not included in any major linux distro repo.

This also kinda makes me think life in Denmark is.. harsh. Esp. when this doesn't seem to provide any better functionality than xargs with -P.
