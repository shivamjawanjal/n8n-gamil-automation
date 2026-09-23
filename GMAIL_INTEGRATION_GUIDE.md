# Google Cloud OAuth 2.0 Setup Guide for Gmail Automation in n8n

To allow n8n to read incoming emails, filter messages, create drafts, or send automated replies using Gmail, you need to create OAuth 2.0 credentials in the Google Cloud Console.

---

## Step 1: Create a Google Cloud Project

1. Go to the [Google Cloud Console](https://console.cloud.google.com/).
2. Click the project dropdown in the top bar > Click **New Project**.
3. Name your project (e.g. `n8n-gmail-automation`) and click **Create**.
4. Select your new project.

---

## Step 2: Enable the Gmail API

1. In the search bar or left sidebar, navigate to **APIs & Services** > **Library**.
2. Search for **Gmail API**.
3. Click on **Gmail API** and click **Enable**.

---

## Step 3: Configure the OAuth Consent Screen

1. In the left menu, click **APIs & Services** > **OAuth consent screen**.
2. Select **External** (or **Internal** if using Google Workspace) and click **Create**.
3. Fill in the required fields:
   - **App name**: `n8n Automation`
   - **User support email**: Your email address
   - **Developer contact information**: Your email address
4. Click **Save and Continue**.
5. On the **Scopes** page:
   - Click **Add or Remove Scopes**.
   - Search and select:
     - `https://mail.google.com/` (or `.../auth/gmail.modify`, `.../auth/gmail.send`, `.../auth/gmail.readonly`)
   - Click **Update** > Click **Save and Continue**.
6. On the **Test Users** page:
   - Click **+ Add Users** and add your Gmail address that you will connect to n8n.
7. Click **Save and Continue** and finish the wizard.

---

## Step 4: Create OAuth 2.0 Client ID

1. In the left menu, click **Credentials**.
2. Click **+ Create Credentials** > Select **OAuth client ID**.
3. Choose **Application type**: `Web application`.
4. Name: `n8n Client`.
5. Under **Authorized redirect URIs**, add the callback URL for your n8n environment:
   - **For Local Development**:
     ```
     http://localhost:5678/rest/oauth2-credential/callback
     ```
   - **For Oracle Cloud (Production)**:
     ```
     https://n8n.yourdomain.com/rest/oauth2-credential/callback
     ```
   *(You can add both URLs to the same client ID!)*
6. Click **Create**.
7. Copy your **Client ID** and **Client Secret**.

---

## Step 5: Connect Gmail Account in n8n

1. Open n8n ([http://localhost:5678](http://localhost:5678) or `https://n8n.yourdomain.com`).
2. In the left sidebar, click **Credentials** > **Add Credential**.
3. Search for **Gmail OAuth2 API**.
4. Paste your **Client ID** and **Client Secret**.
5. Click **Sign in with Google** and approve the permissions.
6. Once connected, your Gmail trigger and send nodes will be fully authenticated!
