cta
===

Worlds smallest kwotes

Setup
=====

cta can be configured as a CGI or FastCGI script. Configure as necessary for your webserver, and

```
cp your/install/location/cta.sqlite.blank your/install/location/cta.sqlite
```

Fortune
=======

Use cta2fortune.pl to generate a fortune db from your kwotes db 8-)

```
./cta2fortune.pl cta.sqlite
```
