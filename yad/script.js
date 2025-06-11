// Constants
const CONFIG = {
    VERSION: '1.0.0',
    GITHUB_BASE_URL: 'https://raw.githubusercontent.com/0xl30/Hyprland-Rice/master/yad',
    UPDATE_CHECK_INTERVAL: 3600000, // Check every hour
    ANIMATION: {
        THRESHOLD: 0.1,
        FADE_DURATION: 800
    },
    TIMEOUT: {
        FETCH: 5000,
        UPDATE_CHECK: 10000
    }
};

// Error Types
class AppError extends Error {
    constructor(message, type, data) {
        super(message);
        this.name = 'AppError';
        this.type = type;
        this.data = data;
        this.timestamp = new Date().toISOString();
    }
}

// Utility functions
const createElementWithClasses = (tag, classes, innerHTML = '') => {
    try {
        const element = document.createElement(tag);
        element.classList.add(...(Array.isArray(classes) ? classes : [classes]));
        if (innerHTML) element.innerHTML = innerHTML;
        return element;
    } catch (error) {
        throw new AppError('Failed to create element', 'DOM_CREATION_ERROR', { tag, classes, innerHTML });
    }
};

// Initialize Intersection Observer for fade-in animations
const initFadeAnimations = () => {
    try {
        const fadeInElements = document.querySelectorAll('.fade-in');
        
        if (fadeInElements.length === 0) return;

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('show');
                    observer.unobserve(entry.target);
                }
            });
        }, { threshold: CONFIG.ANIMATION.THRESHOLD });

        fadeInElements.forEach(element => observer.observe(element));
    } catch (error) {
        handleError(new AppError('Animation initialization failed', 'ANIMATION_ERROR', error));
    }
};

// Version management
const fetchWithTimeout = async (url, timeout = CONFIG.TIMEOUT.FETCH) => {
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), timeout);

    try {
        const response = await fetch(url, { signal: controller.signal });
        clearTimeout(timeoutId);
        
        if (!response.ok) {
            throw new AppError(
                `HTTP error! status: ${response.status}`,
                'FETCH_ERROR',
                { url, status: response.status }
            );
        }
        
        return response;
    } catch (error) {
        clearTimeout(timeoutId);
        if (error.name === 'AbortError') {
            throw new AppError('Request timeout', 'TIMEOUT_ERROR', { url, timeout });
        }
        throw error;
    }
};

const compareVersions = (localVersion, remoteVersion) => {
    try {
        const local = localVersion.split('.').map(Number);
        const remote = remoteVersion.split('.').map(Number);
        
        for (let i = 0; i < 3; i++) {
            if (remote[i] > local[i]) return true;  // New version available
            if (remote[i] < local[i]) return false; // Local version is newer
        }
        return false; // Versions are equal
    } catch (error) {
        console.error('Error comparing versions:', error);
        return false;
    }
};

const checkForNewVersion = async () => {
    try {
        const response = await fetchWithTimeout(
            `${CONFIG.GITHUB_BASE_URL}/version.txt`,
            CONFIG.TIMEOUT.UPDATE_CHECK
        );
        const remoteVersion = await response.text();
        const cleanRemoteVersion = remoteVersion.trim();

        if (compareVersions(CONFIG.VERSION, cleanRemoteVersion)) {
            showUpdateNotification(cleanRemoteVersion);
        }
    } catch (error) {
        handleError(error);
    }
};

// UI Components with Error Boundaries
const createUpdateNotification = () => {
    try {
        return createElementWithClasses('div', 'update-notification', `
            <p>A new version is available!</p>
            <div class="update-buttons">
                <button id="show-update" class="update-btn">
                    <span>View Changes</span>
                </button>
                <a href="./update_with_yad.sh" download="update_with_yad.sh">
                    <button id="install-update" class="update-btn">
                        <span>Install Update</span>
                    </button>
                </a>
            </div>
        `);
    } catch (error) {
        handleError(new AppError('UI creation failed', 'UI_ERROR', error));
        return null;
    }
};

const createVersionPopup = (content, newVersion) => {
    try {
        // Parse the HTML content
        const parser = new DOMParser();
        const doc = parser.parseFromString(content, 'text/html');
        
        // Create the popup structure
        const popup = document.createElement('div');
        popup.className = 'version-popup';
        popup.innerHTML = `
            <div class="version-popup-content">
                <div class="popup-header">
                    <h3>WHAT'S NEW</h3>
                    <button class="close-btn" aria-label="Close">×</button>
                </div>
                <div class="version-entry">
                    <div class="update-banner">
                        <div class="update-icon">
                            <svg viewBox="0 0 24 24" width="24" height="24">
                                <path fill="currentColor" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8zm-1-13h2v6h-2zm0 8h2v2h-2z"/>
                            </svg>
                        </div>
                        <div class="update-text">New Update Available!</div>
                        <button class="install-btn">
                            <span class="btn-text">Update</span>
                            <span class="btn-icon">↓</span>
                        </button>
                    </div>
                    ${formatVersionContent(doc)}
                </div>
            </div>
        `;

        // Add to DOM
        document.body.appendChild(popup);
        
        // Force reflow to ensure transition works
        popup.offsetHeight;
        popup.classList.add('show');

        // Setup close button and install button
        const closeBtn = popup.querySelector('.close-btn');
        const installBtn = popup.querySelector('.install-btn');
        const popupContent = popup.querySelector('.version-popup-content');

        const closePopup = (e) => {
            // Only close if clicking close button or outside content
            if (e && e.target !== closeBtn && e.target.closest('.version-popup-content')) {
                return;
            }
            popup.classList.remove('show');
            popup.addEventListener('transitionend', () => {
                popup.remove();
            }, { once: true });
        };

        // Event listeners
        closeBtn.addEventListener('click', closePopup);
        popup.addEventListener('click', closePopup);
        popupContent.addEventListener('click', e => e.stopPropagation());

        // Install button click handler
        installBtn.addEventListener('click', () => {
            installBtn.classList.add('installing');
            installBtn.innerHTML = '<span class="btn-text">Installing...</span><div class="loader"></div>';
            
            // Simulate installation process
            setTimeout(() => {
                installBtn.classList.remove('installing');
                installBtn.classList.add('installed');
                installBtn.innerHTML = '<span class="btn-text">Installed!</span><span class="btn-icon">✓</span>';
                
                // Close popup after installation
                setTimeout(() => {
                    closePopup();
                }, 1500);
            }, 2000);
        });

        return popup;
    } catch (error) {
        handleError(new AppError('Popup creation failed', 'UI_ERROR', error));
        return null;
    }
};

const formatVersionContent = (doc) => {
    try {
        // Get all version sections
        const versionSections = doc.querySelectorAll('.version-history h2');
        let formattedContent = '';

        // Process each version section
        versionSections.forEach((section, index) => {
            const versionTitle = section.textContent;
            const versionList = section.nextElementSibling;
            const items = versionList ? Array.from(versionList.children).map(item => item.textContent) : [];

            // Create changelog items
            const changelogItems = items.map((item, i) => `
                <div class="changelog-item">${i + 1}. ${item}</div>
            `).join('');

            formattedContent += `
                <div class="version-section ${index === 0 ? 'current' : ''}">
                    <h4>${versionTitle}</h4>
                    <div class="changelog-list">
                        ${changelogItems}
                    </div>
                </div>
            `;
        });

        return formattedContent || '<p class="no-changes">No changelog information available.</p>';
    } catch (error) {
        return '<p class="error-message">Failed to format changelog.</p>';
    }
};

const formatChangelog = (content) => {
    try {
        if (!content || !content.trim()) {
            return '<p class="no-changes">No changelog information available.</p>';
        }

        const lines = content.split('\n')
            .filter(line => line.trim())
            .map((line, index) => {
                return `<div class="changelog-item">${index + 1}.</div>`;
            })
            .join('');

        return `<div class="changelog-list">${lines}</div>`;
    } catch (error) {
        return '<p class="error-message">Failed to format changelog.</p>';
    }
};

const showUpdateNotification = (newVersion) => {
    try {
        // Remove any existing notification first
        const existingNotification = document.querySelector('.update-notification');
        if (existingNotification) {
            existingNotification.remove();
        }

        const notification = createElementWithClasses('div', 'update-notification', `
            <div class="update-message-container">
                <div class="update-message">New(v${newVersion}) is available!</div>
            </div>
            <div class="update-buttons">
                <button id="show-update" class="update-btn">
                    VIEW
                </button>
                <a href="./update_with_yad.sh" download="update_with_yad.sh">
                    <button id="install-update" class="update-btn">
                        INSTALL
                    </button>
                </a>
            </div>
        `);

        if (!notification) return;

        document.body.appendChild(notification);

        const showUpdateBtn = notification.querySelector('#show-update');
        const installUpdateBtn = notification.querySelector('#install-update');

        if (!showUpdateBtn || !installUpdateBtn) {
            throw new AppError('Update buttons not found', 'UI_ERROR');
        }

        const handleShowUpdate = async (event) => {
            try {
                event.preventDefault();
                
                // Disable both buttons during fetch
                showUpdateBtn.disabled = true;
                installUpdateBtn.disabled = true;
                
                // Show loading state
                showUpdateBtn.innerHTML = 'LOADING...';
                
                await fetchVersionDetails(newVersion);
                notification.classList.add('fade-out');
                setTimeout(() => notification.remove(), 300);
            } catch (error) {
                handleError(error);
                
                // Reset button states
                showUpdateBtn.disabled = false;
                installUpdateBtn.disabled = false;
                showUpdateBtn.innerHTML = 'VIEW CHANGES';
            }
        };

        showUpdateBtn.addEventListener('click', handleShowUpdate);
    } catch (error) {
        handleError(error);
    }
};

const fetchVersionDetails = async (newVersion) => {
    try {
        const response = await fetchWithTimeout(
            `${CONFIG.GITHUB_BASE_URL}/version.html`,
            CONFIG.TIMEOUT.FETCH
        );
        const versionContent = await response.text();
        
        if (!versionContent.trim()) {
            throw new AppError('Empty version content received', 'FETCH_ERROR');
        }

        // Remove existing popup if any
        const existingPopup = document.querySelector('.version-popup');
        if (existingPopup) {
            existingPopup.remove();
        }

        // Create and show new popup
        createVersionPopup(versionContent, newVersion);

    } catch (error) {
        handleError(error);
        showErrorMessage('Failed to load update details. Please try again later.');
    }
};

const showErrorMessage = (message, duration = 5000) => {
    try {
        const existingError = document.querySelector('.error-popup');
        if (existingError) {
            existingError.remove();
        }

        const errorPopup = createElementWithClasses('div', 'error-popup', `
            <div class="error-content">
                <p>${message}</p>
                <button class="close-error-btn">Close</button>
            </div>
        `);
        
        document.body.appendChild(errorPopup);
        
        const closeErrorBtn = errorPopup.querySelector('.close-error-btn');
        if (closeErrorBtn) {
            const closeError = () => {
                errorPopup.classList.add('fade-out');
                setTimeout(() => errorPopup.remove(), 300);
            };

            closeErrorBtn.addEventListener('click', closeError);
            
            // Auto-hide error after duration
            if (duration > 0) {
                setTimeout(closeError, duration);
            }
        }
    } catch (error) {
        console.error('Error showing message:', message);
    }
};

// Enhanced Error Handling
const handleError = (error) => {
    const errorTypes = {
        FETCH_ERROR: 'Network request failed',
        TIMEOUT_ERROR: 'Request timed out',
        UI_ERROR: 'UI operation failed',
        ANIMATION_ERROR: 'Animation failed',
        DOM_CREATION_ERROR: 'Failed to create element'
    };

    const errorMessage = error instanceof AppError
        ? errorTypes[error.type] || 'An unexpected error occurred'
        : 'An unexpected error occurred';

    console.error(errorMessage, error);
};

// Initialize
const init = () => {
    try {
        document.addEventListener('DOMContentLoaded', () => {
            initFadeAnimations();
        });

        checkForNewVersion();
        
        // Set up periodic version checks with error handling
        setInterval(() => {
            checkForNewVersion().catch(error => {
                handleError(error);
            });
        }, CONFIG.UPDATE_CHECK_INTERVAL);
    } catch (error) {
        handleError(error);
    }
};

init();
