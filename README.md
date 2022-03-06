# Chihaya on Heroku
[Chihaya](https://github.com/chihaya/chihaya) torrent tracker on Heroku.

Chihaya HTTP torrent tracker tunneled from a worker dyno using [Cloudflare Tunnel client](https://github.com/cloudflare/cloudflared).

As worker dyno do not sleep on free dyno, and in order not to put strain on Heroku's HTTP routers.

## Heroku Deployment
You need Heroku CLI and a configured Cloudflare Tunnel.

1. Clone this repository.
2. Create an app on Heroku.
3. Encode the Cloudflare Tunnel JSON credential in Base64 using this command `base64 -w 0 <cloudflare-tunnel-id>.json`.
4. Set Cloudflare Tunnel configuration encoded in Base64 on config vars `heroku config:set CLOUDFLARE_TUNNEL_CREDENTIAL=<cloudflare-tunnel-credential-base64>`.
5. Encode the Cloudflare Tunnel config.yaml in Base64 using this command `base64 -w 0 config.yaml`.
6. Set Cloudflare Tunnel config.yaml encoded in Base64 on config vars `heroku config:set CLOUDFLARE_TUNNEL_CONFIGURATION=<cloudflare-tunnel-config.yaml-base64>`.

### Deploy by building it on Heroku's server
7. Set git remote to Heroku `heroku git:remote -a your-app-name`.
8. Set stack to container `heroku stack:set container -a your-app-name`.
9. Deploy to Heroku `git push heroku main`.

### Deploy by building it on your computer
You need Docker.

9. Build the image and push to Container Registry `heroku container:push web -a your-app-name`.
10. Release the image `heroku container:release web`.

### Example cloudflared config.yaml file
```yaml
url: http://localhost:6969
tunnel: deadbeef-1234-4321-abcd-123456789abc
credentials-file: /app/cloudflare-tunnel-credential.json
```
With Metrics:
```yaml
tunnel: deadbeef-1234-4321-abcd-123456789abc
credentials-file: /app/cloudflare-tunnel-credential.json

ingress:
  - hostname: tracker.example.com
    service: http://localhost:6969
  - hostname: tracker-metrics.example.com
    service: http://localhost:8080
  - service: http_status:404
```