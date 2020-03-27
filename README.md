Kanta.si
=

This tiny application is a result of numerous days that I spent running
after the garbage truck, shouting at the `Men at Work` to wait for me.

I missed them way too many times.

The second part is the fact that I never know which garbage can I should
put out on the street. I rely solely on the good neighbors to figure
this out.

Last time the whole street had cans out on the street for nothing.

Imagine the time we wasted!
-

So, I wrote an application and now I don't have to worry about this stuff.
It was a really fun way to get more into Elm.

How to?
-

```
$ git clone git@github.com:BigWhale/kanta.si.git kanta
$ cd kanta
$ npm install
$ npm run dev
```
This should probably(?!) do it. Now you can deploy index.html, style.css and elm.js and
you'll know when **I**  have to take out the garbage can.

But you won, because this tiny program is growing and right now it requires a REST API
that will willingly server all the data needed. Things aren't hardcoded anymore.

~~If you want to know when you have to do it, you'll have to change the
calendar entries in the `Main.elm`. It's clumsy, I know.~~

Bugs
-
Currently everything is broken, since I'm in the process of a complete rewrite.
There's a backend server written in Golang and this little application is in
the process of being rewritten.

Using [elm-spa](https://github.com/ryannhg/elm-spa) for routing and [Tailwind UI](https://tailwindui.com/) for
quickly making various front end elements.

OMG, HE (I) BROKE THE BUILD!

