// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


  slideShow = function( t ) {
    currentPane = $('#splash').attr('visible'); 
    
    $('#pane' + currentPane).hide();  
    $('#pane' + t).show();
    $('#splash').attr('visible', t);
  }
  
  slideChange = function( command ) {
    totalPanes = $('#splash').attr('total');
    currentPane = $('#splash').attr('visible');

    if (currentPane < totalPanes) {
      nextPane = currentPane - 0 + 1;
    }
    else if (currentPane >= totalPanes) {
      nextPane = 1;
    }

    if (currentPane > 1) {
      previousPane = currentPane - 0 - 1;
    }
    else if (currentPane <= 1) {
      previousPane = totalPanes;
    }
        
    if (command == "") {
      slideShow(nextPane);
    }
    else if (command == "next") {
      slideShow(nextPane);
    }
    else if (command == "previous") {
      slideShow(previousPane);
    }
  }

  setInterval(slideChange, 5000)