(function () {
  function displaySearchResults(results, store, searchTerm) {
    var searchResults = document.getElementById('search-results');

    if (results.length) { // Are there any results?
      var appendString = '';
      var patt = new RegExp(searchTerm, 'ig');
      for (var i = 0; i < results.length; i++) {  // Iterate over the results
        var item = store[results[i].ref];
        //var matched = patt.exec( item.content);

        appendString += '<li><a href="' + item.url + '"><b>' + item.title + '</b></a>';
        while ((matched = patt.exec(item.content)) !== null) {
          appendString += '<p><small>' + '... ' +
            item.content.substring(matched.index - 30, matched.index) + '<b>' +
            item.content.substring(matched.index, matched.index + matched[0].length) +
            '</b>' +
            item.content.substring(matched.index + matched[0].length, matched.index + matched[0].length + 30) +
            '...</small></p>'
        }

        appendString += '</li>';
      }

      searchResults.innerHTML = appendString;
    } else {
      searchResults.innerHTML = '<li>No results found</li>';
    }
  }

  function getQueryVariable(variable) {
    var query = window.location.search.substring(1);
    var vars = query.split('&');

    for (var i = 0; i < vars.length; i++) {
      var pair = vars[i].split('=');

      if (pair[0] === variable) {
        return decodeURIComponent(pair[1].replace(/\+/g, '%20'));
      }
    }
  }

  var searchTerm = getQueryVariable('query');

  if (searchTerm) {
    document.getElementById('search-box').setAttribute("value", searchTerm);

    // Initalize lunr with the fields it will be searching on. I've given title
    // a boost of 10 to indicate matches on this field are more important.
    var idx = lunr(function () {
      this.field('id');
      this.field('title', { boost: 10 });
      this.field('author');
      this.field('category');
      this.field('content');
    });

    for (var key in window.store) { // Add the data to lunr
      idx.add({
        'id': key,
        'title': window.store[key].title,
        'author': window.store[key].author,
        'category': window.store[key].category,
        'content': window.store[key].content
      });

      var results = idx.search(searchTerm); // Get lunr to perform a search
      displaySearchResults(results, window.store, searchTerm);
    }
  }
})();
