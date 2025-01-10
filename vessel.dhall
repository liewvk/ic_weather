let upstream = https://github.com/dfinity/vessel-package-set/releases/download/mo-0.10.0-20230911/package-set.dhall sha256:cb9482b7ac159b54b77d6001ca7a5fc44c35164f8567c9c7385cf37fd6494f2d

let Package =
    { name : Text, version : Text, repo : Text, dependencies : List Text }

let additions = [
  { name = "http"
  , repo = "https://github.com/aviate-labs/http.mo"
  , version = "v0.2.0"
  , dependencies = [ "base" ]
  }
] : List Package

in  upstream # additions
