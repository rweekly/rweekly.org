---
layout: page
title: About
---

**Weekly Updates from the Entire R Community**

## Community

### Facebook

<div class="fb-page" data-href="https://www.facebook.com/rweekly/" data-small-header="false" data-adapt-container-width="true" data-hide-cover="false" data-show-facepile="true">
<a
  href="https://www.facebook.com/rweekly/">
Follow Facebook</a>
</div>

<p></p>

### Twitter

<a class="twitter-follow-button"
  href="https://twitter.com/rweekly_org"
  data-size="large">
Follow @rweekly_org</a>

### LinkedIn

<a
  href="https://www.linkedin.com/organization/rweekly"
  data-size="large">
Follow LinkedIn</a>

### Submit

Go to [https://rweekly.org/submit](https://rweekly.org/submit)

Submit your links and scripts for R Weekly posts and podcasts.

### Pull Requests

Update the [draft](https://github.com/rweekly/rweekly.org/blob/gh-pages/draft.md) post, and create a pull request.

### Communication

<iframe src="https://docs.google.com/forms/d/e/1FAIpQLSdJQYyu0jDpU3MkbNHv4Trl8DrRemlIJr9_-rfyrkNYcmpZNA/viewform?embedded=true" width="100%" height="500" frameborder="0" marginheight="0" marginwidth="0">Feedback Form</iframe>

Have a question or great idea about this website? 

Talk with us on [Twitter](https://twitter.com/rweekly_org) or [Google Groups](https://groups.google.com/forum/#!forum/rweekly).

Thanks for reading!

### Name

<strong>R</strong> <strong>W</strong>eekly for the name, and <strong>RW</strong>eekly.org for the URL.

## More on R Weekly


### R conferences & meetups

<a href="https://conf.rweekly.org">https://conf.rweekly.org</a>

A collection of presentation slides/materials released on various R conferences and meetups.

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
    if (localStorage.getItem("feature-toc") === 'true'){
        localStorage.setItem("feature-toc", false);
        _paq.push(['trackEvent', 'set-toc', 'false']);
        document.getElementById('toc-status').innerText = " Off ";
        window.location.reload();
    } else {
        localStorage.setItem("feature-toc", true);
        _paq.push(['trackEvent', 'set-toc', 'true']);
        document.getElementById('toc-status').innerText = " On ";
        window.location.reload();
    }
}

document.getElementById('toc-status').addEventListener("click",toc_feature);

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

