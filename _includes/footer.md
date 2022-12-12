
<form id="search-form" target="_blank" action="/search.html" method="get">
<label for="search-box"></label>
<input type="text" class="github-search-box" id="search-box" name="query" placeholder="search">
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

Do you enjoy R Weekly?

<div id="star-rating" class="rating" style="margin-bottom:10px;" >
<span class="stars-item" data-value="5">☆</span><span class="stars-item" data-value="4">☆</span><span class="stars-item" data-value="3">☆</span><span class="stars-item" data-value="2">☆</span><span class="stars-item" data-value="1">☆</span>
</div>

<form id="submit-form" class="hided-form pure-form" style="margin-bottom: 20px;">
    <p id="res-text">Thanks for your feedback!</p>
    <fieldset class="pure-group">

        <textarea id="submit-desc" required="" style="width: 90%" class="pure-input-1 submit-form-90 " placeholder="More ideas about R Weekly"></textarea>
        <input id="submit-email" style="width: 90%" class="pure-input-1 submit-form-90" placeholder="contact">
    </fieldset>

    <button id="link-submit" type="submit" class="pure-button pure-input pure-button-primary" style="width:90%;display: inline-block;">Submit</button>
</form>
<div style="display: none;" id="dialog" title="Submission Status">
  <p></p>
</div>

<script>

function stars_on_clicks() {
    if(this.getAttribute('click-done') !== "true"){
        // handle stars
        var stars = document.querySelectorAll('#star-rating .stars-item');
        var chosen_value = parseInt(this.getAttribute('data-value'));

        for(var jj=0; jj!=stars.length;jj++){
            var curr = parseInt(stars[jj].getAttribute('data-value'));
            if (curr > chosen_value){
                stars[jj].innerHTML = '';
            }else{
                stars[jj].innerHTML = "★";
            }
            stars[jj].setAttribute('click-done',"true");
        }

        // handle xhr
        var final_url = "https://api.rweekly.org/rating?value=" + chosen_value + "&path=" + encodeURIComponent(window.location.href);

        var xhr = new XMLHttpRequest();
        var time_xhr = (new Date()).getTime();
        xhr.open("GET", final_url);
        xhr.onreadystatechange = function() {
            if (xhr.readyState == 4 && ( xhr.status == 200 || xhr.status == 304 )) {
                var xhr_res = JSON.parse(xhr.responseText);
                if (xhr_res.hasOwnProperty('error')){
                    document.getElementById('res-text').innerHTML = 'Thanks! You already voted today!';
                    _paq.push(['trackEvent', "submit-rating", "error", xhr_res.error, (new Date()).getTime() - time_xhr]);
                } else {
                    _paq.push(['trackEvent', "submit-rating", "done", chosen_value, (new Date()).getTime() - time_xhr]);
                }
            }
        }
        xhr.send();
        _paq.push(['trackEvent', "submit-rating", "begin", chosen_value]);

        // handle show form
        document.getElementById('submit-form').classList.remove('hided-form');
        document.getElementById('submit-form').setAttribute('stars-num', chosen_value);

    }
}

document.addEventListener("DOMContentLoaded", function () {
    var stars = document.querySelectorAll('#star-rating .stars-item');
    for(var ii=0; ii!=stars.length;ii++){
        stars[ii].addEventListener("click", stars_on_clicks.bind(stars[ii]));
        stars[ii].addEventListener("touchend", stars_on_clicks.bind(stars[ii]));
    };

    document.getElementById( "submit-form" ).addEventListener( "submit", function(e) {
    e.preventDefault();

    var final_url = {};
    final_url.value = (document.getElementById('submit-form').getAttribute('stars-num'));
    final_url.desc = (document.getElementById('submit-desc').value);
    final_url.email = (document.getElementById('submit-email').value);

    var xhr = new XMLHttpRequest();
    var time_xhr = (new Date()).getTime();
    xhr.open("POST", "https://api.rweekly.org/feedback", true);
    xhr.onreadystatechange = function() {
        if (xhr.readyState == 4 && ( xhr.status == 200 || xhr.status == 304 )) {
            var xhr_res = JSON.parse(xhr.responseText);
            if (xhr_res.hasOwnProperty('error')){
                document.getElementById('dialog').firstElementChild.innerHTML = 'Sorry, there are too many requests. You can also talk to us with Twitter or Google Group!';
                _paq.push(['trackEvent', "submit-feedback", "error", (new Date()).getTime() - time_xhr]);
            } else {
                _paq.push(['trackEvent', "submit-feedback", "done", (new Date()).getTime() - time_xhr]);
                var words;

                document.getElementById('dialog').firstElementChild.innerHTML = 'Thanks for your feedback!';
                document.getElementById('submit-desc').value = '';
                document.getElementById('submit-email').value = '';
            }
            $( "#dialog" ).dialog({
                show: {
                    effect: "fade",
                    duration: 300
                },
                hide: {
                    effect: "fade",
                    duration: 300
                }
            });
        }
    }
    xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
    xhr.send(JSON.stringify(final_url));
    _paq.push(['trackEvent', "submit-feedback", "begin"]);
    });
});

</script>

[R](https://www.r-project.org/) is a free software environment for statistical computing and graphics.

R Weekly @ [Facebook](https://facebook.com/rweekly), [Twitter](https://twitter.com/rweekly_org), [Mastodon](https://fosstodon.org/@rweekly)

This website uses [cookies](/privacy).

**R Weekly** is openly developed [on GitHub](https://github.com/rweekly/rweekly.org). Send us [feedback](https://rweekly.org/about.html#communication).

<p class="hide-support added-hostname support-rweekly"></p>

<div id="fb-root"></div>
