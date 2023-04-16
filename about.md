---
layout: purecss-page
title: About
---

**Weekly Updates from the Entire R Community**

## About Us

R Weekly was founded on May 20, 2016. R is growing very quickly, and there are lots of great blogs, tutorials and other formats of resources coming out every day. R Weekly wants to keep track of these great things in the R community and make it more accessible to everyone.

This is a warm and welcoming place. The team welcomes everyone who wants to contribute to the R community.

Team Members (alphabet order)

[Batool Almarzouq](https://github.com/BatoolMM), [Colin Fay](https://github.com/ColinFay), [Eric Nantz](https://github.com/thercast), [Jon Calder](https://github.com/jonmcalder), [Jonathan Carroll](https://github.com/jonocarroll), [Kelly N. Bodwin](https://github.com/kbodwin), [Miles McBain](https://github.com/MilesMcBain), [Robert Hickman](https://github.com/RobWHickman), [Ryo Nakagawara](https://github.com/Ryo-N7), [Sam Parmar](https://github.com/parmsam), [Tony ElHabr](https://github.com/tonyelhabr), [Wolfram Qin](https://github.com/qinwf)


## Social Medias

R Weekly @

[Facebook](https://facebook.com/rweekly), [Twitter](https://twitter.com/rweekly_org)

[YouTube Channel](https://www.youtube.com/channel/UCVRffxCKJd2qQ6gDcoMPxJQ)

[LinkedIn](https://www.linkedin.com/company/rweekly), [dev.to()](https://dev.to/rweekly)

[Support with Patreon](https://www.patreon.com/rweekly)

### Submit

Go to [https://rweekly.org/submit](https://rweekly.org/submit)

Submit your links and scripts for R Weekly posts and podcasts.

💡 Use [W3C Feed Validation](https://validator.w3.org/feed/)  Service to checks the syntax of Atom or RSS feeds.

### Pull Requests

Update the [draft](https://github.com/rweekly/rweekly.org/blob/gh-pages/draft.md) post, and create a pull request.

### Communication

Do you enjoy R Weekly?

5 stars for R Weekly fans! 😍

<div id="star-rating-1" class="rating" style="margin-bottom:10px;" >
<span class="stars-item" data-value="5">☆</span><span class="stars-item" data-value="4">☆</span><span class="stars-item" data-value="3">☆</span><span class="stars-item" data-value="2">☆</span><span class="stars-item" data-value="1">☆</span>
</div>

<form id="submit-form-1" class="hided-form pure-form" style="margin-bottom: 20px;">
    <p id="res-text-1">Thanks for your feedback!</p>
    <fieldset class="pure-group">

        <textarea id="submit-desc-1" required="" style="width: 90%" class="pure-input-1 submit-form-90 " placeholder="More ideas about R Weekly"></textarea>
        <input id="submit-email-1" style="width: 90%" class="pure-input-1 submit-form-90" placeholder="contact">
    </fieldset>

    <button id="link-submit-1" type="submit" class="pure-button pure-input pure-button-primary" style="width:90%;display: inline-block;">Submit</button>
</form>
<div style="display: none;" id="dialog-1" title="Submission Status">
  <p></p>
</div>

<script>

function stars_on_clicks_1() {
            if(this.getAttribute('click-done') !== "true"){
                // handle stars
                var chosen_value = parseInt(this.getAttribute('data-value'));
                var stars = document.querySelectorAll('#star-rating-1 .stars-item');
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
                            document.getElementById('res-text-1').innerHTML = 'Thanks! You already voted today!';
                            _paq.push(['trackEvent', "submit-rating", "error", xhr_res.error, (new Date()).getTime() - time_xhr]);
                        } else {
                            _paq.push(['trackEvent', "submit-rating", "done", chosen_value, (new Date()).getTime() - time_xhr]);
                        }
                    }
                }
                xhr.send();
                _paq.push(['trackEvent', "submit-rating", "begin", chosen_value]);

                // handle show form
                document.getElementById('submit-form-1').classList.remove('hided-form');
                document.getElementById('submit-form-1').setAttribute('stars-num', chosen_value);

            }
        }

document.addEventListener("DOMContentLoaded", function () {
    var stars = document.querySelectorAll('#star-rating-1 .stars-item');
    for(var ii=0; ii!=stars.length;ii++){
        stars[ii].addEventListener("click", stars_on_clicks_1.bind(stars[ii]));
        stars[ii].addEventListener("touchend", stars_on_clicks_1.bind(stars[ii]));
    };

    document.getElementById( "submit-form-1" ).addEventListener( "submit", function(e) {
    e.preventDefault();

    var final_url = {};
    final_url.value = (document.getElementById('submit-form-1').getAttribute('stars-num'));
    final_url.desc = (document.getElementById('submit-desc-1').value);
    final_url.email = (document.getElementById('submit-email-1').value);

    var xhr = new XMLHttpRequest();
    var time_xhr = (new Date()).getTime();
    xhr.open("POST", "https://api.rweekly.org/feedback", true);
    xhr.onreadystatechange = function() {
        if (xhr.readyState == 4 && ( xhr.status == 200 || xhr.status == 304 )) {
            var xhr_res = JSON.parse(xhr.responseText);
            if (xhr_res.hasOwnProperty('error')){
                document.getElementById('dialog-1').firstElementChild.innerHTML = 'Sorry, there are too many requests. You can also talk to us with Twitter or Google Group!';
                _paq.push(['trackEvent', "submit-feedback", "error", (new Date()).getTime() - time_xhr]);
            } else {
                _paq.push(['trackEvent', "submit-feedback", "done", (new Date()).getTime() - time_xhr]);
                var words;

                document.getElementById('dialog-1').firstElementChild.innerHTML = 'Thanks for your feedback!';
                document.getElementById('submit-desc-1').value = '';
                document.getElementById('submit-email-1').value = '';
            }
            $( "#dialog-1" ).dialog({
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

Have a question or great idea about this website?

Talk with us on [Twitter](https://twitter.com/rweekly_org), [dev.to()](https://dev.to/rweekly) or [Google Groups](https://groups.google.com/forum/#!forum/rweekly).

Thanks for reading!

### Name

<strong>R</strong> <strong>W</strong>eekly for the name, and <strong>RW</strong>eekly.org for the URL.

## More on R Weekly


<!-- ### R conferences & meetups

<a href="https://conf.rweekly.org">https://conf.rweekly.org</a>

A collection of presentation slides/materials released on various R conferences and meetups. -->

### Blog

<a href="https://blog.rweekly.org">https://blog.rweekly.org</a>

Updates and changes on R Weekly.

### Search

<a href="https://rweekly.org/search">https://rweekly.org/search</a>

[Search](./search.html) interesting R posts.

### Random

<a href="https://rweekly.org/random">https://rweekly.org/random</a>

Read [random](./random.html) R posts.

## Options

### Show Origin

Show hostnames of URLs. Status: <a id="origin-status" href="#">On</a>

<script>
if (localStorage.getItem("origin") === 'false'){
    document.getElementById('origin-status').innerText = " Off ";
} else {
    document.getElementById('origin-status').innerText = " On ";
}

function originMode(e) {
    e.preventDefault();
    if (localStorage.getItem('origin') === 'true') {
        localStorage.setItem('origin', 'false');
        document.body.classList.remove('show-origin');
        document.body.classList.add('hide-origin');
        _paq.push(['trackEvent', 'set-origin', 'false']);
        document.getElementById('origin-status').innerText = " Off ";
    } else if (localStorage.getItem('origin') === 'false') {
        localStorage.setItem('origin', 'true');
        document.body.classList.add('show-origin');
        document.body.classList.remove('hide-origin');
        _paq.push(['trackEvent', 'set-origin', 'true']);
        document.getElementById('origin-status').innerText = " On ";
    } else {
        localStorage.setItem('origin', 'false');
        document.body.classList.add('hide-origin');
        document.body.classList.remove('show-origin');
        _paq.push(['trackEvent', 'set-origin', 'false']);
        document.getElementById('origin-status').innerText = " Off ";
    }
}

document.getElementById('origin-status').addEventListener("click",originMode);

</script>

### Podcast Corner

Podcast Corner. Status: <a id="pod-corner-status" href="#">On</a>

<script>
if (localStorage.getItem("feature-podcast-corner") === 'true'){
    document.getElementById('pod-corner-status').innerText = " On ";
} else {
    document.getElementById('pod-corner-status').innerText = " Off ";
}

function pod_corner_feature(e){
    e.preventDefault();
    if (localStorage.getItem("feature-podcast-corner") === 'false'){
        localStorage.setItem("feature-podcast-corner", true);
        _paq.push(['trackEvent', 'set-pod', 'true']);
        document.getElementById('pod-corner-status').innerText = " On ";
        window.location.reload();
    } else {
        localStorage.setItem("feature-podcast-corner", false);
        _paq.push(['trackEvent', 'set-pod', 'false']);
        document.getElementById('pod-corner-status').innerText = " Off ";
        window.location.reload();
    }
}

document.getElementById('pod-corner-status').addEventListener("click",pod_corner_feature);

</script>


### TOC

Display TOC. Status: <a id="toc-status" href="#">On</a>

<script>
if (localStorage.getItem("feature-toc") === 'false'){
    document.getElementById('toc-status').innerText = " Off ";
} else {
    document.getElementById('toc-status').innerText = " On ";
}

function toc_feature(e){
    e.preventDefault();
    if (localStorage.getItem("feature-toc") === 'false'){
        localStorage.setItem("feature-toc", true);
        _paq.push(['trackEvent', 'set-toc', 'true']);
        document.getElementById('toc-status').innerText = " On ";
        window.location.reload();
    } else {
        localStorage.setItem("feature-toc", false);
        _paq.push(['trackEvent', 'set-toc', 'false']);
        document.getElementById('toc-status').innerText = " Off ";
        window.location.reload();
    }
}

document.getElementById('toc-status').addEventListener("click",toc_feature);

</script>

### Show Support

Show how to support R Weekly team. Status: <a id="support-status" href="#">On</a>

<script>
if (localStorage.getItem("feature-support") === 'false'){
    document.getElementById('support-status').innerText = " Off ";
} else {
    document.getElementById('support-status').innerText = " On ";
}

function support_feature(e){
    e.preventDefault();
    if (localStorage.getItem("feature-support") === 'false'){
        localStorage.setItem("feature-support", true);
        _paq.push(['trackEvent', 'set-support', 'true']);
        document.getElementById('support-status').innerText = " On ";
        window.location.reload();
    } else {
        localStorage.setItem("feature-support", false);
        _paq.push(['trackEvent', 'set-support', 'false']);
        document.getElementById('support-status').innerText = " Off ";
        window.location.reload();
    }
}

document.getElementById('support-status').addEventListener("click",support_feature);

</script>

### Like - Testing Feature

Keep a reading list in the browser with the posts you like. Status: <a id="like-status" href="#">Off</a>

<script>
if (localStorage.getItem("feature-like") === 'true'){
    document.getElementById('like-status').innerText = " On ";
} else {
    document.getElementById('like-status').innerText = " Off ";
}

function like_feature(e){
    e.preventDefault();
    if (localStorage.getItem("feature-like") === 'true'){
        localStorage.setItem("feature-like", false);
        _paq.push(['trackEvent', 'set-like', 'false']);
        document.getElementById('like-status').innerText = " Off ";
    } else {
        localStorage.setItem("feature-like", true);
        _paq.push(['trackEvent', 'set-like', 'true']);
        document.getElementById('like-status').innerText = " On ";
    }
}

document.getElementById('like-status').addEventListener("click",like_feature);

</script>

