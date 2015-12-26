/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;
/******/
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/*!**************************************!*\
  !*** ./app/assets/frontend/main.jsx ***!
  \**************************************/
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();
	
	var _IssueBox = __webpack_require__(/*! ./components/IssueBox */ 2);
	
	var _IssueBox2 = _interopRequireDefault(_IssueBox);
	
	var _IssueList = __webpack_require__(/*! ./components/IssueList */ 3);
	
	var _IssueList2 = _interopRequireDefault(_IssueList);
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }
	
	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }
	
	function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }
	
	function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }
	
	var Main = (function (_React$Component) {
	  _inherits(Main, _React$Component);
	
	  function Main(props) {
	    _classCallCheck(this, Main);
	
	    var _this = _possibleConstructorReturn(this, Object.getPrototypeOf(Main).call(this, props));
	
	    _this.state = { issueList: [] };
	    return _this;
	  }
	
	  _createClass(Main, [{
	    key: 'addIssue',
	    value: function addIssue(issueToAdd) {
	      var _this2 = this;
	
	      $.post("/apis/issues", { tag: issueToAdd }).success(function (savedIssue) {
	        if (savedIssue.type == 'success') {
	          var newIssueList = _this2.state.issueList;
	          newIssueList.unshift(savedIssue.data);
	          _this2.setState({ issueList: newIssueList });
	        } else {
	          console.log(savedIssue.message);
	        }
	      }).error(function (error) {
	        return console.log(error);
	      });
	    }
	  }, {
	    key: 'componentDidMount',
	    value: function componentDidMount() {
	      var _this3 = this;
	
	      $.ajax("/apis/issues").success(function (data) {
	        return _this3.setState({ issueList: data });
	      }).error(function (error) {
	        return console.log(error);
	      });
	    }
	  }, {
	    key: 'render',
	    value: function render() {
	      return React.createElement(
	        'div',
	        { className: 'container' },
	        React.createElement(_IssueBox2.default, { sendIssue: this.addIssue.bind(this) }),
	        React.createElement(_IssueList2.default, { issues: this.state.issueList })
	      );
	    }
	  }]);
	
	  return Main;
	})(React.Component);
	
	var documentReady = function documentReady() {
	  var reactNode = document.getElementById('issues');
	  if (reactNode) {
	    ReactDOM.render(React.createElement(Main, null), reactNode);
	  }
	};
	
	$(documentReady);

/***/ },
/* 1 */,
/* 2 */
/*!*****************************************************!*\
  !*** ./app/assets/frontend/components/IssueBox.jsx ***!
  \*****************************************************/
/***/ function(module, exports) {

	'use strict';
	
	var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();
	
	Object.defineProperty(exports, "__esModule", {
	  value: true
	});
	
	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }
	
	function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }
	
	function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }
	
	var IssueBox = (function (_React$Component) {
	  _inherits(IssueBox, _React$Component);
	
	  function IssueBox() {
	    _classCallCheck(this, IssueBox);
	
	    return _possibleConstructorReturn(this, Object.getPrototypeOf(IssueBox).apply(this, arguments));
	  }
	
	  _createClass(IssueBox, [{
	    key: 'sendIssue',
	    value: function sendIssue(event) {
	      event.preventDefault();
	      this.props.sendIssue(this.refs.issueArea.value);
	      this.refs.issueArea.value = '';
	    }
	  }, {
	    key: 'render',
	    value: function render() {
	      return React.createElement(
	        'div',
	        { className: 'issue_box' },
	        React.createElement(
	          'form',
	          { className: 'timer', onSubmit: this.sendIssue.bind(this) },
	          React.createElement('input', { type: 'text', ref: 'issueArea', placeholder: 'What are you working on?' }),
	          React.createElement(
	            'button',
	            { type: 'submit' },
	            'submit'
	          )
	        ),
	        React.createElement('div', { className: 'clear' })
	      );
	    }
	  }]);
	
	  return IssueBox;
	})(React.Component);
	
	exports.default = IssueBox;

/***/ },
/* 3 */
/*!******************************************************!*\
  !*** ./app/assets/frontend/components/IssueList.jsx ***!
  \******************************************************/
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };
	
	var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();
	
	Object.defineProperty(exports, "__esModule", {
	  value: true
	});
	
	var _Issue = __webpack_require__(/*! ./Issue */ 4);
	
	var _Issue2 = _interopRequireDefault(_Issue);
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }
	
	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }
	
	function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }
	
	function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }
	
	var IssueList = (function (_React$Component) {
	  _inherits(IssueList, _React$Component);
	
	  function IssueList() {
	    _classCallCheck(this, IssueList);
	
	    return _possibleConstructorReturn(this, Object.getPrototypeOf(IssueList).apply(this, arguments));
	  }
	
	  _createClass(IssueList, [{
	    key: 'render',
	    value: function render() {
	      var issues = this.props.issues.map(function (issue) {
	        return React.createElement(_Issue2.default, _extends({ key: issue.id }, issue));
	      });
	      return React.createElement(
	        'div',
	        { className: 'issue_list' },
	        React.createElement(
	          'ul',
	          null,
	          issues
	        )
	      );
	    }
	  }]);
	
	  return IssueList;
	})(React.Component);
	
	exports.default = IssueList;

/***/ },
/* 4 */
/*!**************************************************!*\
  !*** ./app/assets/frontend/components/Issue.jsx ***!
  \**************************************************/
/***/ function(module, exports) {

	'use strict';
	
	var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();
	
	Object.defineProperty(exports, "__esModule", {
	  value: true
	});
	
	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }
	
	function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }
	
	function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }
	
	var Issue = (function (_React$Component) {
	  _inherits(Issue, _React$Component);
	
	  function Issue() {
	    _classCallCheck(this, Issue);
	
	    return _possibleConstructorReturn(this, Object.getPrototypeOf(Issue).apply(this, arguments));
	  }
	
	  _createClass(Issue, [{
	    key: 'render',
	    value: function render() {
	      return React.createElement(
	        'li',
	        null,
	        React.createElement(
	          'strong',
	          { className: 'user' },
	          this.props.name,
	          ': '
	        ),
	        React.createElement(
	          'span',
	          { className: 'body' },
	          this.props.body
	        ),
	        React.createElement(
	          'span',
	          { className: 'time' },
	          this.props.time
	        )
	      );
	    }
	  }]);
	
	  return Issue;
	})(React.Component);
	
	exports.default = Issue;

/***/ }
/******/ ]);
//# sourceMappingURL=bundle.js.map