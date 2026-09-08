const productContainer = document.getElementById("products");
const productCount = document.getElementById("product-count");

const filterForm = document.getElementById("filter-form");
const searchInput = document.getElementById("search");
const priceInput = document.getElementById("price-below");

const resetButton = document.getElementById("reset-button");
const refreshButton = document.getElementById("refresh-button");


async function loadProducts() {
    productContainer.innerHTML = "<p>Loading products...</p>";

    const params = new URLSearchParams();

    const search = searchInput.value.trim();
    const priceBelow = priceInput.value;

    if (search) {
        params.set("search", search);
    }

    if (priceBelow) {
        params.set("price_below", priceBelow);
    }

    const query = params.toString();

    const url = query
        ? `/api/products?${query}`
        : "/api/products";

    try {
        const response = await fetch(url);

        if (!response.ok) {
            throw new Error("Failed to load products");
        }

        const products = await response.json();

        renderProducts(products);

    } catch (error) {
        console.error(error);

        productContainer.innerHTML = `
            <p class="error">
                Failed to load products.
            </p>
        `;

        productCount.textContent = "Unable to load products";
    }
}


function renderProducts(products) {

    productCount.textContent =
        `${products.length} product${products.length !== 1 ? "s" : ""} found`;

    if (products.length === 0) {
        productContainer.innerHTML = `
            <div class="empty">
                <h3>No products found</h3>
                <p>Try another search or price range.</p>
            </div>
        `;

        return;
    }

    productContainer.innerHTML = products
        .map(product => createProductCard(product))
        .join("");
}


function createProductCard(product) {

    const stockLabel =
        product.stock > 0
            ? `${product.stock} in stock`
            : "Sold out";

    return `
        <article class="product-card">

            <div class="product-image">
                <span>${product.category}</span>
            </div>

            <div class="product-content">

                <div class="product-category">
                    ${product.category}
                </div>

                <h3>${product.name}</h3>

                <p class="description">
                    ${product.description ?? ""}
                </p>

                <div class="product-footer">

                    <strong>
                        Rp${product.price.toLocaleString("id-ID")}
                    </strong>

                    <span class="${product.stock > 0 ? "stock" : "sold-out"}">
                        ${stockLabel}
                    </span>

                </div>

            </div>

        </article>
    `;
}


filterForm.addEventListener("submit", event => {
    event.preventDefault();

    loadProducts();
});


resetButton.addEventListener("click", () => {

    searchInput.value = "";
    priceInput.value = "";

    loadProducts();
});


refreshButton.addEventListener("click", () => {
    loadProducts();
});


loadProducts();