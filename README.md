# R-dom Coffeescript

This is a wrapper library to make r-dom [https://github.com/uber/r-dom], a React DOM wrapper, compatible with Coffeescript
syntax. This makes it possible to write clean but powerful React DOM code without using extraneous brackets and commas or
using the much maligned JSX.

## Usage

```coffee
React = require 'react'
r = require 'r-dom-coffeescript'
{ div, h1, h2, ul, li } = require 'r-dom-coffeescript'

AnotherComponent = require './another-component.coffee'

module.exports = class ExampleComponent extends Component
  render: ->
    div '.example', # Class selector
      h1 'Hello World!'
      h2 'This is React.js markup'
      r AnotherComponent, { foo: 'bar' }
      div        
        classSet: # Automatically use `classnames` module for classSet
          foo: @props.foo
          bar: @props.bar
        isRendered: @props.foo # div won't render if isRendered is falsy
        ul '.tasks', # Children come after props
          li 'Item 1'
          li 'Item 2'
          li 'Item 3'
```

## Documentation

#### `r[tag](properties, children)`

Returns a React element

- **tag** `String` - A React.DOM tag string
- **properties** `Object` - An object containing the properties you'd like to set on the element
- **children** `Array|String` - An array of `r` children or a string. This will create child elements or a text node, respectively.

#### `r(component, properties, children)`

Returns a React element

- **component** `Function` - A React.js Component class created with `React.createClass`
- **properties** `Object` - An object containing the properties you'd like to set on the element
- **children** `Array|String` - An array of `r` children or a string. This will create child elements or a text node, respectively.

#### Special Properties

- **isRendered** `"Boolean"` - If falsy, React will skip rendering the target component.
- **classSet** `Object` - Apply React.addons.classSet() automatically and assign to className.

#### Selector

This library also adds an optional class/id selector as the first parameter for adding CSS classes or an id in Hyperscript
syntax. The following example adds CSS id 'main' and classes 'example' and 'hidden' to the 'h1' node.

```coffee
h1 '#main.example.hidden', 'Hello World!'
```

## Making r-dom-coffeescript tags global

You can import all tags to your global namespace to make them available in your whole project. This is optional and
at your own risk (be sure to avoid name conflicts).

```coffee
@r = require 'r-dom-coffeescript'

for tag of r
  @[tag] = r[tag]
```

## Bonus tip: separate template files

Some people prefer to have their DOM code in separate template files. This can be done in the following way.

app.coffee:

```coffee
Task = require './task.coffee'
template = require './app.template.coffee'

module.exports = class App extends Component
  renderTasks: ->
    @props.tasks.map (task) =>
      r Task, key: task._id, task: task

  render: ->
    template.call(@)
```

app.template.coffee:

```coffee
module.exports = ->
  div '.container',
    header '',
      h1 'Todo List'
      ul '',
        @renderTasks()
```

## Caveats

To make Coffeescript indenting work with r-dom tags without any selector or props, one has to place a dummy parameter on the
first line. This can be either an empty selector `''`, or empty props `{}`. See the following example.

```coffee
ul '',
  li 'Item 1'
  li 'Item 2'
  li 'Item 3'
```

## Example project

The following Meteor project is available as an example [https://github.com/njjkgeerts/simple-todos-r-dom-coffeescript].

## License

MIT
