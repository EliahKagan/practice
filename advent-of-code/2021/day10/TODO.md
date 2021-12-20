# TODO

`pyright` reports `reportPrivateImportUsage` on access to `bidict.bidict`
(whether in a `from`&hellip;`import` or otherwise). Accessing
`bidict._bidict.bidict` avoids the &ldquo;error&rdquo;, but it seems to me that
this is much worse, since, `_bidict`, being &ldquo;non-public,&rdquo; could
change at any time.

`mypy` does not report this error, at least with a current version of `mypy`,
but this bug report in `bidict` seems to capture the `pyright` situation
accurately: https://github.com/jab/bidict/issues/154

I think the best way to deal with this is a suppression. I don&rsquo;t know how
to do a suitably narrow suppression for this, for `pyright`.
