// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


  slideShow = function( t ) {
    panes = $('#splash');
        
    $('#pane' + t).show();
    $('#splash').attr('visble', t);
  }
