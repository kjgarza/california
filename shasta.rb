require 'citeproc'
require 'csl/styles'

# Create a new processor with the desired style,
# format, and locale.
cp = CiteProc::Processor.new style: 'apa', format: 'text'

# To see what styles are available in your current
# environment, run `CSL::Style.ls'; this also works for
# locales as `CSL::Locale.ls'.

# Tell the processor where to find your references. In this
# example we load them from a BibTeX bibliography using the
# bibtex-ruby gem.
cp.import BibTeX.open('./references.bib').to_citeproc

# Now you are ready for rendering; the processor API
# provides three main rendering methods: `process',
# `append', or `bibliography'.

# For simple one-off renditions, you can also call
# `render' in bibliography or citation mode:
cp.render :bibliography, id: 'knuth'

# This will return a rendered reference, like:
#-> Knuth, D. (1968). The art of computer programming. Boston: Addison-Wesley.

# CiteProc-Ruby exposes a full CSL API to you; this
# makes it possible to just alter CSL styles on the
# fly. For example, what if we want names not to be
# initialized even though APA style is configured to
# do so? We could change the CSL style itself, but
# we can also make a quick adjustment at runtime:
name = cp.engine.style.macros['author'] > 'names' > 'name'

# What just happened? We selected the current style's
# 'author' macro and then descended to the CSL name
# node via its parent names node. Now we can change
# this name node and the cite processor output will
# pick-up the changes right away:
name[:initialize] = 'false'

cp.render :bibliography, id: 'knuth'
#-> Knuth, Donald. (1968). The art of computer programming (Vol. 1). Boston: Addison-Wesley.

# Note that we have picked 'text' as the output format;
# if we want to make us of richer output formats we
# can switch to HTML instead:
cp.engine.format = 'html'

cp.render :bibliography, id: 'knuth'
#-> Knuth, Donald. (1968). <i>The art of computer programming</i> (Vol. 1). Boston: Addison-Wesley.

# You can also render citations on the fly.
cp.render :citation, id: 'knuth', locator: '23'
#-> (Knuth, 1968, p. 23)