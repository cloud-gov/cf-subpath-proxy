# cf-subpath-proxy

## Why this project

Sometimes applications aren't well-behaved when Cloud Foundry serves them from a route with a `--path`. One way to handle this situation is to use a proxy app as a front-end which strips the path from the request before it reaches the problem app. The misbehaving app will see all requests arriving via `/` instead of a subpath, avoiding broken behavior. You can use the [NGINX buildpack](https://docs.cloudfoundry.org/buildpacks/nginx/index.html) to implement such a proxy application, as demonstrated here.

For example, running [R Shiny](https://shiny.rstudio.com/) apps on [Cloud Foundry](https://www.cloudfoundry.org/) works great thanks to the [R Buildpack](https://docs.cloudfoundry.org/buildpacks/r/index.html)... until you try to map your R Shiny app a route to with a `--path`! If you do that you're likely to see requests for JS and CSS resources from a `/shared` path that doesn't map to your app, and your app will appear broken. (You may be tempted to try tweaking R code and route config, but that way lies madness. Hence, this example.)


## Preparing to use the proxy
### Configuration
The configuration for NGINX is in the `nginx.conf` file in this repo. We've referenced [an example from the Shiny documentation](https://support.rstudio.com/hc/en-us/articles/213733868-Running-Shiny-Server-with-a-Proxy) for the content.

### Pushing to Cloud Foundry
1. Clone this repo and copy `manifest.yml-dist` to `manifest.yml`.
1. Edit `manifest.yml` to set the application name and hostname+domain path.
1. Run `cf push`.
1. If the misbehaving app on is a `.internal` domain, add a network policy enabling the proxy to reach it. For example:
  `cf add-network-policy subpath-strip-proxy --destination-app <appname>`

--- 

## Contributing

See [CONTRIBUTING](CONTRIBUTING.md) for additional information.

## Public domain

This project is in the worldwide [public domain](LICENSE.md). As stated in [CONTRIBUTING](CONTRIBUTING.md):

> This project is in the public domain within the United States, and copyright and related rights in the work worldwide are waived through the [CC0 1.0 Universal public domain dedication](https://creativecommons.org/publicdomain/zero/1.0/).
>
> All contributions to this project will be released under the CC0 dedication. By submitting a pull request, you are agreeing to comply with this waiver of copyright interest.
