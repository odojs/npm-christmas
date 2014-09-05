# npm-christmas

The opposite of shrinkwrap, releases all your versions.


Usage: `npm-christmas [wrap or unwrap]` (defaults to unwrap)

unwrap: Your `package.json` file will have it's dependency versions replaced with *

wrap: Your `package.json` file will pick up versions from your currently installed packages

Use npm shrinkwrap for a more robust wrap

`npm-christmas` or `npm-christmas unwrap`

```

 √ Releasing colors from 0.6.2 to *

   Presents unwrapped

```

`npm-christmas wrap`

```

 √ Locking colors to 0.6.2

   Presents wrapped

```