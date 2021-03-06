// Generated by CoffeeScript 1.7.1
(function() {
  angular.module('watchCtrl', ['User', 'Meeting', 'UAService']).controller('watchCtrl', function($scope, $stateParams, UAService, User, Meeting) {
    var drawLine, drawPageImage, init, initSubscribe;
    drawPageImage = function(pageId) {
      var canvasWrapperWidth, ctx, hgtWidRate, img, pageCanvas;
      pageCanvas = document.getElementById('pageCanvas');
      ctx = pageCanvas.getContext("2d");
      canvasWrapperWidth = $('#canvas-wrapper').width();
      img = document.getElementById('page' + pageId);
      hgtWidRate = img.height / img.width;
      if (img.width > canvasWrapperWidth) {
        pageCanvas.width = canvasWrapperWidth;
      } else {
        pageCanvas.width = img.width;
      }
      pageCanvas.height = pageCanvas.width * hgtWidRate;
      $scope.scaleRate = pageCanvas.width / img.width;
      ctx.scale($scope.scaleRate, $scope.scaleRate);
      ctx.drawImage(img, 0, 0);
      return $scope.isCurrentPageDrawed = true;
    };
    drawLine = function(linePath, lineColor, lineWidth) {
      var ctx, i, lastX, lastY, pageCanvas, _fn, _i, _ref;
      if (lineColor == null) {
        lineColor = '#4bf';
      }
      if (lineWidth == null) {
        lineWidth = 6;
      }
      pageCanvas = document.getElementById('pageCanvas');
      ctx = pageCanvas.getContext("2d");
      ctx.beginPath();
      lastX = linePath[0];
      lastY = linePath[1];
      ctx.moveTo(lastX, lastY);
      _fn = function(i) {
        var currentX, currentY;
        currentX = lastX + linePath[i];
        currentY = lastY + linePath[i + 1];
        ctx.lineTo(currentX, currentY);
        lastX = currentX;
        return lastY = currentY;
      };
      for (i = _i = 2, _ref = linePath.length - 1; _i <= _ref; i = _i += 2) {
        _fn(i);
      }
      ctx.lineWidth = lineWidth;
      ctx.strokeStyle = lineColor;
      return ctx.stroke();
    };
    init = function() {
      $scope.meetingId = $stateParams.meetingId;
      $scope.currentPageId = 1;
      $scope.maxPageId = 1;
      $scope.isCurrentPageDrawed = false;
      $scope.scaleRate = 1;
      $scope.isDownGraded = UAService.isDownGraded();
      $scope.refreshMeetingData($scope.meetingId);
      return initSubscribe($scope.meetingId);
    };
    $(window).on('resize', function(e) {
      return drawPageImage($scope.currentPageId);
    });
    $scope.$on('meeting_data_loaded', function() {
      $scope.maxPageId = $scope.meeting.ppt.pageCount;
      $scope.readyPageImagesId = [];
      return $scope.$on('page_image_loaded', function(event, pageId) {
        $scope.readyPageImagesId.push(pageId);
        if (pageId === $scope.currentPageId && !$scope.isCurrentPageDrawed) {
          return drawPageImage(pageId);
        }
      });
    });
    $scope.refreshMeetingData = function(meetingId) {
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
    $scope.$on('updatePage', function(a, pageId) {
      $scope.currentPageId = pageId;
      drawPageImage(pageId);
      return $scope.$apply();
    });
    $scope.$on('drawLine', function(event, line) {
      return drawLine(line.path, line.color, line.width);
    });
    initSubscribe = function(meetingId) {
      io.socket.on('meeting', function(obj) {
        var line, pageId;
        if (obj.verb === 'messaged') {
          if (obj.data.type === 'updatePage') {
            pageId = parseInt(obj.data.pageId);
            return $scope.$broadcast('updatePage', pageId);
          } else {
            if (obj.data.type === 'drawLine') {
              line = JSON.parse(obj.data.line);
              $scope.$broadcast('drawLine', line);
            }
          }
        }
      });
      io.socket.get('/meeting/subscribeWatch', {
        meetingId: meetingId
      });
      return true;
    };
    return init();
  });

}).call(this);

//# sourceMappingURL=watchCtrl.map
