const { parallel, series, src, dest, watch } = require('gulp');
const postcss       = require('gulp-postcss');
const postimport    = require('postcss-import');
const tailwindcss   = require('tailwindcss');
const mv            = require('gulp-rename');
const uglify        = require('gulp-uglify');
const sourcemap     = require('gulp-sourcemaps');
const purgecss      = require('postcss-purgecss');
const postcsspreset = require('postcss-preset-env');

class TailwindExtractor {
    static extract (content) {
        return content.match(/[A-Za-z0-9-_:/]+/g) || []
    }
}

function makelist(cb) {
    return src('assets/elm/src/Main.elm')
        .pipe(search({
            regex: /class "([^"]*)"/g,
            file: '/tmp/strings.json'
        }))
        .pipe(dest('.'));
}

function cssbuild (cb) {
    let custom = [
        "h-6",
        "inline-block",
        "svg-icon-lib",
        "svg",
        "svg-icon",
        "img",
        "ul",
        "background-none",
        "fill",
        "-mt-2",
        "gallery-size-large",
        "gallery-item",
        "gallery-icon",
        "wpcf7",
        "rounded",
        "border",
        "border-gray",
        "w-full",
        "h-8",
        "pl-2",
        "pr-2",
        "w-full",
        "login-form",
        "input",
];

    let terms = JSON.parse(fs.readFileSync('/tmp/strings.json').toString());
    let keys = Object.keys(terms).map( s => s.trim());

    let reduced = keys.join(" ").split(" ").filter(function (e, i, s) {
        return i === s.indexOf(e);
    });

    let whitelist = purgecsswp.whitelist.concat(reduced).concat(custom);

    src('assets/css/app.pcss')
        .pipe(sourcemap.init())
        .pipe(postcss([
            postimport(),
            tailwindcss('./tailwind.config.js'),
            require('autoprefixer'),
            postcsspreset({stage: 1}),
            purgecss({
                content: ['**/*.php', './assets/css/**/*.css', './assets/js/**/*.js'],
                extractors: [{
                    extractor: TailwindExtractor,
                    extensions: ['php', 'css', 'js'],
                }],
                whitelist: whitelist,
                whitelistPatterns: purgecsswp.whitelistPatterns
            }),
            require('cssnano')
            ]))
        .pipe(sourcemap.write())
        .pipe(mv('app.min.css'))
        .pipe(dest('css/'));
    src(['assets/blocks/gallery-editor-style.css',
         'assets/blocks/gallery-style.css'])
        .pipe(dest('css/'));
    src(['node_modules/lightgallery/dist/css/lightgallery.css',
         'node_modules/lightgallery/dist/css/lg-transitions.css'])
        .pipe(dest('css/'));
    return cb();
}

function cssdev (cb) {
    src('assets/css/app.pcss')
        .pipe(postcss([
            postimport(),
            tailwindcss('./tailwind.config.js'),
            require('autoprefixer'),
            postcsspreset({stage: 1}),
        ]))
        .pipe(mv('styles.css'))
        .pipe(dest('public/css'));
    return cb();
}

function watchdev() {
    watch([ 'src/**/*.elm',
            'assets/css/*.pcss',
            'tailwind.config.js'],
        series(cssdev)
    );
}

exports.makelist = makelist;
exports.cssdev = cssdev;
exports.default = series(cssdev, watchdev);
exports.build = series(makelist, cssbuild);
