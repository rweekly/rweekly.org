
<form id="search-form" target="_blank" action="/search.html" method="get">
<label for="search-box"></label>
<input type="text" id="search-box" name="query" placeholder="search">
</form>

<script>
document.getElementById('search-form').addEventListener('submit', function(e){ 
    e.preventDefault();
    var value_search = document.getElementById('search-box').value;
    _paq.push(['trackSiteSearch',
        value_search,
        document.URL,
        0
    ]);
    setTimeout(function(){
       document.location = "https://github.com/rweekly/rweekly.org/search?utf8=%E2%9C%93&q=" + encodeURIComponent(value_search) + "+extension%3Ar+extension%3Amd&type=Code";
    }, 250);
});
</script>



<hr/>


<div class="fb-page" data-href="https://www.facebook.com/rweekly/" data-small-header="false" data-adapt-container-width="true" data-hide-cover="false" data-show-facepile="true"></div>

<p></p>

Subscribe R Weekly with <a href="https://feedburner.google.com/fb/a/mailverify?uri=rweekly&amp;loc=en_US" target="_blank" onclick="_paq.push(['trackEvent', 'Mail', '1']);">Email</a>.

R Weekly @ [Twitter](https://twitter.com/rweekly_org) [Facebook](https://facebook.com/rweekly) [LinkedIn](https://www.linkedin.com/company/rweekly)

[R](https://www.r-project.org/) is a free software environment for statistical computing and graphics. 

**R Weekly** is openly developed [on GitHub](https://github.com/rweekly/rweekly.org). Send us [feedback](https://rweekly.org/more.html#feedback).

R Weekly uses [cookies](/privacy) to improve user experience.

<div id="fb-root"></div>
