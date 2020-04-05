# cf-subpath-proxy

## What's the problem?

Sometimes applications are sensitive to the URLs used to make requests, and misbehave when Cloud Foundry serves them from a route with a `--path`, either not responding or trying to find their assets in an unrelated location.

### That's too vague... What's an example of an app that misbehaves?
Running [R Shiny](https://shiny.rstudio.com/) apps on [Cloud Foundry](https://www.cloudfoundry.org/) works great thanks to the [R Buildpack](https://docs.cloudfoundry.org/buildpacks/r/index.html)... until you try to map your R Shiny app a route to with a `--path`! Then you'll see a `404 Not Found` message from the Shiny app. 

If you provide a `uiPattern` parameter matching the path when you set up the app object in your R code, you'll see the app respond, but request JS and CSS assets from a `/shared` path. Those assets won't be found, and the app will appear broken.

This means R Shiny apps break two of the [12-factors](https://12factor.net/config) for well-behaved applications:

* [Configuration should be separate from the app](https://12factor.net/config): A Shiny app should not care about how requests are routed to it, or whether there's a path in the URL.
* [Dependencies should be isolated](https://12factor.net/dependencies): A Shiny app should not request JS and CSS from an unrelated app or location.

## What's the solution?

We can restore these two factors by isolating the misbehaving application, then using a proxy app as a front-end to strip the path from the request before it reaches the problem app. The misbehaving app will see all requests arriving via `/` instead of a subpath, avoiding the broken behavior. 

Here we use the [`php-buildpack`](https://docs.cloudfoundry.org/buildpacks/php/index.html) to implement such a proxy – by disabling PHP and taking advantage of the pre-installed Apache web server -, referencing [an example from the Shiny documentation](https://support.rstudio.com/hc/en-us/articles/213733868-Running-Shiny-Server-with-a-Proxy).

## Using the proxy
1. Map the misbehaving app to a route on `app.cloud.gov` (formerly suggested internal routes don't have sticky session features), eg `<appname>.app.cloud.gov`.
1. Clone this repo and copy `manifest.yml-dist` to `manifest.yml`.
1. Edit `manifest.yml` to set the application name and hostname+domain path.
1. Run `cf push`.
1. Add a network policy enabling the proxy to reach the misbehaving app. For example:
  `cf add-network-policy subpath-proxy --destination-app <appname>`
1. Open `example.appdomain/<appname>` in your browser.

--- 

## Contributing

See [CONTRIBUTING](CONTRIBUTING.md) for additional information.

## Public domain

This project is in the worldwide [public domain](LICENSE.md). As stated in [CONTRIBUTING](CONTRIBUTING.md):

> This project is in the public domain within the United States, and copyright and related rights in the work worldwide are waived through the [CC0 1.0 Universal public domain dedication](https://creativecommons.org/publicdomain/zero/1.0/).
>
> All contributions to this project will be released under the CC0 dedication. By submitting a pull request, you are agreeing to comply with this waiver of copyright interest.
