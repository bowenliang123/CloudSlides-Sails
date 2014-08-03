// Generated by CoffeeScript 1.7.1
(function() {
  var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  angular.module('controlCtrl', ['User', 'Meeting']).controller('controlCtrl', function($scope, $stateParams, $timeout, User, Meeting) {
    var drawPageImage, init;
    $scope.drawPageImage = function(pageId) {
      return drawPageImage(pageId);
    };
    drawPageImage = function(pageId) {
      var canvasWrapperWidth, ctx, hgtWidRate, img, pageCanvas, scaleRate;
      pageCanvas = document.getElementById('pageCanvas');
      ctx = pageCanvas.getContext("2d");
      canvasWrapperWidth = $('#canvas-wrapper').width();
      img = document.getElementById('page' + pageId);
      hgtWidRate = img.height / img.width;
      pageCanvas.width = img.width > canvasWrapperWidth ? canvasWrapperWidth : img.width;
      pageCanvas.height = pageCanvas.width * hgtWidRate;
      scaleRate = pageCanvas.width / img.width;
      ctx.scale(scaleRate, scaleRate);
      ctx.drawImage(img, 0, 0);
      $scope.isCurrentPageDrawed = true;
      return $scope.$broadcast('canvas_scale_rate_changed', scaleRate);
    };
    init = function() {
      $scope.meetingId = $stateParams.meetingId;
      $scope.currentPageId = 1;
      $scope.maxPageId = 1;
      $scope.isCurrentPageDrawed = false;
      $scope.refreshMeetingData($scope.meetingId);
      $scope.isEnabledDrawing = true;
      $scope.lineColor = 'blue';
      $scope.lineColorSet = {
        blue: {
          colorCode: '#4bf',
          text: '蓝色'
        },
        red: {
          colorCode: '#C0392B',
          text: '红色'
        }
      };
      $scope.lineWidthType = 'narrow';
      return $scope.lineWidthSet = {
        narrow: {
          width: 4,
          text: '细笔'
        },
        mid: {
          width: 7,
          text: '中笔'
        },
        wide: {
          width: 10,
          text: '粗笔'
        }
      };
    };
    $(window).on('resize', function(e) {
      return drawPageImage($scope.currentPageId);
    });
    $scope.$watch('isEnabledDrawing', function(newValue, oldValue) {
      return $scope.$broadcast('change_is_enabledrawing', newValue);
    });
    $scope.$watch('lineColor', function(newValue, oldValue) {
      return $scope.$broadcast('change_line_color', $scope.lineColorSet[newValue].colorCode);
    });
    $scope.$watch('lineWidthType', function(newValue, oldValue) {
      console.log('lineWidthType' + newValue);
      return $scope.$broadcast('change_line_width', $scope.lineWidthSet[newValue].width);
    });
    $scope.$on('draw_line', function(e, line) {
      return io.socket.post('/meeting/drawLine', {
        meetingId: $scope.meetingId,
        pageId: $scope.currentPageId,
        line: JSON.stringify(line)
      });
    });
    $scope.$on('meeting_data_loaded', function() {
      $scope.maxPageId = $scope.meeting.ppt.pageCount;
      $scope.readyPageImagesId = [];
      $scope.$on('page_image_loaded', function(event, pageId) {
        $scope.readyPageImagesId.push(pageId);
        if (pageId === $scope.currentPageId && !$scope.isCurrentPageDrawed) {
          return drawPageImage(pageId);
        }
      });
    });
    $scope.refreshMeetingData = function() {
      console.log('refreshMeetingData');
      $scope.meeting = {};
      return Meeting.get({
        id: $scope.meetingId
      }, function(value, responseHeaders) {
        var _i, _ref, _results;
        $scope.meeting = value;
        $scope.pageRange = (function() {
          _results = [];
          for (var _i = 1, _ref = $scope.meeting.ppt.pageCount; 1 <= _ref ? _i <= _ref : _i >= _ref; 1 <= _ref ? _i++ : _i--){ _results.push(_i); }
          return _results;
        }).apply(this);
        return $scope.$broadcast('meeting_data_loaded');
      }, function(httpResponse) {
        return console.log(httpResponse);
      });
    };
    $scope.updatePageId = function(pageId) {
      if (pageId < 1 || pageId > $scope.maxPageId) {

      } else {
        $scope.currentPageId = pageId;
        io.socket.post('/meeting/updatePage', {
          meetingId: $scope.meetingId,
          pageId: pageId
        });
        $scope.isCurrentPageDrawed = false;
        if (__indexOf.call($scope.readyPageImagesId, pageId) >= 0) {
          return drawPageImage(pageId);
        }
      }
    };
    init();
    return null;
  });

}).call(this);

//# sourceMappingURL=controlCtrl.map
