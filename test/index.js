var assert = require('chai').assert;
var r = require('../dist/index.js');

describe('r', function() {
  describe('tag without children', function() {
    var el = r.div();

    it("should have correct type", function() {
      return assert.equal(el.type, 'div');
    });

    it('should have empty props', function() {
      return assert.deepEqual(el.props, {});
    });
  });

  describe('tag with children', function() {
    var el = r.div('#main.container.padded', { a: 1, b: 2}, [r.h1(), r.p()]);

    it("should have correct type", function() {
      return assert.equal(el.type, 'div');
    });

    it("should have id", function() {
      return assert.equal(el.props.id, 'main');
    });

    it("should have correct classes", function() {
      return assert.equal(el.props.className, 'container padded');
    });

    it("should have props", function() {
      return assert.equal(el.props.a, 1);
      return assert.equal(el.props.b, 2);
    });

    it("should have children", function() {
      return assert.equal(el.props.children.length, 2);
    });
  });

  describe('tag with extra params', function() {
    var el = r.div(r.h1(), undefined, r.h2(), [], r.p(), null, [r.p(), [r.p()]]);

    it("should have correct type", function() {
      return assert.equal(el.type, 'div');
    });

    it("should have no id or className", function() {
      return assert.equal(el.props.id, undefined);
      return assert.equal(el.props.className, undefined);
    });

    it('should have no props except children', function() {
      return assert.deepEqual(Object.keys(el.props), ['children']);
    });

    it("should have children", function() {
      return assert.equal(el.props.children.length, 5);
    });
  });
});
