# Ruby on Rails Tutorial sample application
=> this is my rails + react version of the following... <=

This is the sample application for
[*Ruby on Rails Tutorial:
Learn Web Development with Rails*]
(https://www.railstutorial.org/)
(6th Edition)
by [Michael Hartl](https://www.michaelhartl.com/).
## License
All source code in the [Ruby on Rails Tutorial]
(https://www.railstutorial.org/)
is available jointly under the MIT License and the Beerware
License. See
[LICENSE.md](LICENSE.md) for details.
5. The README also makes reference to a LICENSE file, which I’ve added
by hand to the official reference implementation, but it isn’t present by
default. You can download a copy from the reference implementation
repository if you want it for completeness, but it’s not necessary for
completing the tutorial.
5
## Getting started
To get started with the app, clone the repo and then install
the needed gems:
```
$ bundle install --without production
```
Next, migrate the database:
```
$ rails db:migrate
```
Finally, run the test suite to verify that everything is
working correctly:
```
$ rails test
```
If the test suite passes, you'll be ready to run the app in a
local server:
```
$ rails server
```
For more information, see the
[*Ruby on Rails Tutorial* book]
(https://www.railstutorial.org/book).