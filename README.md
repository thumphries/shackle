# shackle

Shackle aims to be a loosely-coupled static site generator.

It should be mostly a collection of portable, single-purpose shell
scripts and a Makefile to stitch things together.

It should trivially enable the use of CLI tools like `pandoc` for
content transformation and metadata augmentation.

It should trivially enable the use of user-supplied folds over
metadata.

## Why?

Shackle should work out of the box on any of my machines
without compiling anything. Any transformations I need can be provided
as shell scripts or rigged up in the Makefile using readily-available
CLI tools.

## What is wrong with you?

I have no excuses for this. None. It's a horrifying, anti-intellectual
exercise undertaken with yesterday's troubled tools for dubious
reasons.

The templating system executes arbitrary shell commands. There is
substantial risk you'll make a mistake and find yourself executing
strings. You also need to fully trust the content you're rendering.
