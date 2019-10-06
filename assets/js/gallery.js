import * as SimpleLightbox from "simple-lightbox"

let lightBox = new SimpleLightbox({
    elements: document.querySelectorAll('.photo-panel img'),
    urlAttribute: 'src',
    captionAttribute: 'alt'
});

export default lightBox