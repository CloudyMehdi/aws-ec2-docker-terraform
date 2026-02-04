function display() {
    
    const $dynamicParagraph = document.querySelector("#dynamic-paragraph");
    const $inputBalise = document.querySelector("#main-input");
    $dynamicParagraph.textContent = $inputBalise.value;
    $inputBalise.value = "";
    
}