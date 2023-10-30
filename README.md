# Movie Sunday (movie-sunday)

A Quasar Project

## Install Quasar
```
npm install -g @quasar/cli
```

## Install the dependencies
```bash
yarn
# or
npm install
```

### If npm install fails
```
npm config set registry https://registry.npmjs.org/
rm -rf node_modules
rm package-lock.json
npm cache clean -f
<!-- make sure cache is empty -->
npm cache verify
npm install --omit=optional
```

### Start the app in development mode (hot-code reloading, error reporting, etc.)
```bash
quasar dev
```


### Lint the files
```bash
yarn lint
# or
npm run lint
```


### Format the files
```bash
yarn format
# or
npm run format
```



### Build the app for production
```bash
quasar build
```

### Customize the configuration
See [Configuring quasar.config.js](https://v2.quasar.dev/quasar-cli-webpack/quasar-config-js).
