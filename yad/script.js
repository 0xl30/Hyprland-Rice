// JavaScript to add fade-in animations when scrolling
document.addEventListener("DOMContentLoaded", function() {
    const fadeInElements = document.querySelectorAll(".fade-in");

    const options = {
        threshold: 0.1
    };

    const observer = new IntersectionObserver(function(entries, observer) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add("show");
                observer.unobserve(entry.target); // Stop observing once it's visible
            }
        });
    }, options);

    fadeInElements.forEach(element => {
        observer.observe(element);
    });
});
