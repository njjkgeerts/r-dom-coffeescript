React = require 'react'
rDom = require 'r-dom'

isSelector = (param) ->
  typeof param == 'string' && (param == '' || param[0] == '.' || param[0] == '#')

isProps = (param) ->
  !Array.isArray(param) && typeof param == 'object' && param.$$typeof != Symbol.for('react.element')

parseSelectorProps = (param) ->
  props = {}
  className = parseClassName(param)
  if className?
    props.className = className
  id = parseId(param)
  if id?
    props.id = id
  props

parseClassName = (param) ->
  className = null
  matches = param.match /(\.[^#|^\.]+)/g
  if matches?
    for match in matches
      if className?
        # Append and remove '.'
        className = "#{className} #{match.slice(1)}"
      else
        className = match.slice(1)
  className

parseId = (param) ->
  matches = param.match /(#[^#|^\.]+)/g
  if matches?
    # Assign the last matched id and remove '#'
    matches[matches.length - 1].slice 1
  else
    null

parseChildren = (children) ->
  # Always return children as a flat array
  if Array.isArray(children)
    flatChildren = []
    for child in children
      flatChildren = flatChildren.concat parseChildren(child)
    flatChildren
  else if children?
    [children]
  else
    []

mergeProps = (props, extraProps) ->
  if props.className? && extraProps.className?
    console.warn "RDomCoffeescript: a className is already defined in selector with value '#{props.className}'"
  if props.id? && extraProps.id?
    console.warn "RDomCoffeescript: an id is already defined in selector with value '#{props.id}'"
  for key of extraProps
    props[key] = extraProps[key]
  props

# Parse extra params to make R-Dom compatible with Coffeescript syntax
r = (component, selector, props, extraParams...) ->
  children = []
  mergedProps = {}

  # If div/id selector is passed merge them, otherwise shift them
  if isSelector(selector)
    mergedProps = parseSelectorProps(selector)
  else
    extraParams = parseChildren(props).concat extraParams
    props = selector

  # If props are present merge them, otherwise add to children
  if isProps(props)
    mergedProps = mergeProps(mergedProps, props)
  else
    children = children.concat parseChildren(props)

  # Add any extra params as children
  for param in extraParams
    children = children.concat parseChildren(param)

  rDom component, mergedProps, children

# Create helper for React.DOM tag
createHelper = (tag) ->
  (selector, props, extraParams...)->
    r(tag, selector, props, extraParams)

# Create helpers for all the React.DOM tags
for tag of React.DOM
  if React.DOM.hasOwnProperty tag
    r[tag] = createHelper(tag)

module.exports = r
