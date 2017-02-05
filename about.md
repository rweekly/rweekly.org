---
layout: page
title: About
---

## Weekly Updates from the Entire R Community

### Pull Requests

Update the [draft](https://github.com/rweekly/rweekly.org/blob/gh-pages/draft.md) post, and create a pull request.

### Join the Group

Join us to keep the history of the entire R community, and you will be able to edit this repo. 

After your first 5 pull requests, please take this [survey](https://docs.google.com/forms/d/1WdCjXvWJ1tDSlZNJAroGWCWcqqDjRMAF2VNnZCfn14g/viewform) to join us.

If you are not accepted at first, please do not be discouraged. Create more pull requests to interact with us to let us know more about each other! 

### Communication

Have a question or great idea about this website? 

Talk with us on [Twitter](https://twitter.com/rweekly_org) or [Google Groups](https://groups.google.com/forum/#!forum/rweekly).

Thanks for reading!

## More on R Weekly


### R conferences & meetups

<a href="https://conf.rweekly.org">https://conf.rweekly.org</a>

A collection of presentation slides/materials released on various R conferences and meetups.

### Blog - TBA

<a href="https://blog.rweekly.org">https://blog.rweekly.org</a>

Updates and changes on R Weekly.

### Search

<a href="https://rweekly.org/search">https://rweekly.org/search</a>

[Search](./search.html) interesting R posts.

### Random

<a href="https://rweekly.org/random">https://rweekly.org/random</a>

Read [random](./random.html) R posts.

### Like - Testing Feature

Keep a reading list in the browser with the posts you like. Status: <a id="like-status" href="#">Off</a>

<script>
if (localStorage.getItem("feature-like")){
    document.getElementById('like-status').innerText = " On ";
} else {
    document.getElementById('like-status').innerText = " Off ";
}

function like_feature(e){
    e.preventDefault();
    if (localStorage.getItem("feature-like")){
        localStorage.setItem("feature-like", false);
        document.getElementById('like-status').innerText = " Off ";
    } else {
        localStorage.setItem("feature-like", true);
        document.getElementById('like-status').innerText = " On ";
    }
}

document.getElementById('like-status').addEventListener("click",like_feature);

</script>
