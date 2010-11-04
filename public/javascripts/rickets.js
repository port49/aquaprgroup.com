var Rickets = {

  redirect: function( url ) {
    if( url ) {
      document.location = url;
    }
  },

  redirectNewWindow: function( url ) {
    if( url ) {
      window.open( url, '_blank' );
    }
  },

  showRow: function( row ) {
    tr = $( row );
    if( tr.length == 1 ) {
      Rickets.redirect( tr.attr( 'id' ) );
    }
  },

  selectRow: function( tr ) {
    row = $( tr );
    if( row.hasClass( 'selected' ) ) {
      row.removeClass( 'selected' );
    } else {
      // Only one selected row at a time.
      Rickets.unSelectRows( row.parent() );
      row.addClass( 'selected' );
    }
  },

  unSelectRows: function( row_set ) {
    var rows = row_set.children();
    rows.removeClass( 'selected' );
  },

  findSelectedRow: function( table, volume_level ) {
    var tr = table.find( "tr.selected:first" );
    if( tr.length < 1 ) {
			if( volume_level != 'quiet') {
	      alert( "Please select a row first." );
			}
      return false;
    } else {
      return tr;
    }
  },

  extractId: function( url ) {
    parts = url.split( "/" );
    return parts.pop();
  },
  
  newChildForSelectedRow: function( table, url ) {
    var match = Rickets.findSelectedRow( table, 'quiet' );
    if( match ) {
      document.location = url + '?parent_id=' + Rickets.extractId( match.attr('id') );
    }
		else {
			document.location = url + '?parent_id=0'
		}
  },

  redirectToSelectedRow: function( table ) {
    var tr = Rickets.findSelectedRow( table );
    if( tr ) {
      Rickets.showRow( tr );
    }
  },

  destroySelectedRow: function( table ) {
    var tr = Rickets.findSelectedRow( table );
    if( tr ) {
      var c = confirm( "Really delete this?" );
      if( c ) {
        $.post( tr.attr('id'), { _method:'delete' }, null, 'script' );
      }
    }
  },

  toggleCheckboxToPanel: function( checkbox, panel ) {
    if( $F(checkbox) ) {
      $( panel ).show();
    } else {
      $( panel ).hide();
    }
  },

  toggleSelectOptionToPanel: function( select, option_value, panel ) {
    if( $F(select) == option_value ) {
      $( panel ).show();
    } else {
      $( panel ).hide();
    }
  },

  destroySelectedListItem: function( li ) {
    var match = $( li );
    if( match ) {
      var c = confirm( "Really delete this forever?" );
      if( c ) {
        match.remove();
      }
    }
  },

  insertAssociatedItem: function( container, url, object_uri ) {
    var parts = object_uri.split( "/" );
    var object_id = parts.pop();
    var object_type = parts.pop()
    $.ajax( {
      data: 'object_id=' + object_id + '&object_type=' + object_type,
      success: function( request ){ $( container ).prepend( request ); },
      url: url
    } )
  },

  insertContainedItem: function(ul, li) {
    var id   = $(li).attr('itemid');
    var type = $(li).attr('itemtype');
    var name = $(li).html();
    $(ul).append('<li class=\'ui-corner-all full\'><div>'+name+'<input name=\''+type+'[]\' type=\'hidden\' value=\''+id+'\' /><button class=\'small-inline ui-corner-all\' onclick=\'$(this.parentNode.parentNode).remove()\' type=\'button\'>x</button></div></li>');
  },

  publishForm: function( button ) {
	  var c = confirm( "Accept all pending changes and publish this to the live site?" );
	  if(c) {
	    $(button.form).add("<input name='workflow' value='publish' />");
	    button.form.submit();
	  }
  },
  
  revertForm: function( button ) {
    var c = confirm( "Revert to last published version and destroy all pending changes?" );
    if( c ) {
      $('workflow').value='revert';
      button.form.submit();
    }
  },
  
  // We want something like media_list[]=page_3&media_list[]=video_6&media_list[]=page_5
  serializeSortable: function( button, sortable ) {
    button.form.action = button.form.action + "?" + $( sortable ).sortable( 'serialize', { attribute:'position', expression:'(.+)[\|](.+)' } );
    return true;
  },

  createLinkListItem: function(ul, resource_name){
    var title = $('#links_title').val();
    var url = $('#links_url').val();
    $(ul).append('<li><a href=\''+url+'\' target=\'_blank\'>'+title+'</a><input name=\''+resource_name+'[links][][title]\' type=\'hidden\' value=\''+title+'\' /><input name=\''+resource_name+'[links][][url]\' type=\'hidden\' value=\''+url+'\' /><button class=\'small-inline ui-corner-all\' onclick=\'$(this.parentNode).remove()\' type=\'button\'>x</button></li>');
    $(ul).sortable();
  }
  
}

String.prototype.toCamelCase = function(){
  return $.map( this.split( / |_/ ), function( word ){
    return word.charAt(0).toUpperCase() + word.substr(1).toLowerCase();
  } ).join( "" );
}
