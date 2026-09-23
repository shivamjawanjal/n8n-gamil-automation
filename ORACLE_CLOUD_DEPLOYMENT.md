# Complete Guide: Deploying n8n on Oracle Cloud Infrastructure (OCI)

This guide walks you through deploying your **n8n** automation instance onto Oracle Cloud's **Always Free Tier** with persistent storage and automatic **HTTPS/SSL** via Caddy.

---

## Prerequisites
1. An **Oracle Cloud Infrastructure (OCI)** account.
2. A **Domain Name** (or a free subdomain like `yourname.duckdns.org`).
3. An SSH client (PowerShell, Windows Terminal, or PuTTY).

---

## Step 1: Create an Always Free Compute Instance on OCI

1. Log into your [Oracle Cloud Console](https://cloud.oracle.com/).
2. Navigate to **Compute** > **Instances** > Click **Create Instance**.
3. Configure the instance:
   - **Name**: `n8n-server`
   - **Image**: `Canonical Ubuntu 24.04` or `Ubuntu 22.04` (Recommended).
   - **Shape**:
     - *Option A (Best)*: **Ampere ARM** (`VM.Standard.A1.Flex`, 2–4 OCPUs, 12–24 GB RAM — Always Free eligible).
     - *Option B*: **AMD** (`VM.Standard.E2.1.Micro`, 1 OCPU, 1 GB RAM — Always Free eligible).
4. **Networking**: Choose your default VCN and Public Subnet. Ensure **Assign a public IPv4 address** is selected.
5. **Add SSH Keys**: Download or paste your public SSH key (`id_rsa.pub` or `id_ed25519.pub`).
6. Click **Create** and wait for the instance to transition to **Running**.
7. Note down the **Public IP Address** assigned to your VM.

---

## Step 2: Configure Oracle Cloud Firewall (VCN Security List)

By default, Oracle Cloud blocks all incoming ports except SSH (Port 22). You must allow HTTP and HTTPS traffic:

1. In the OCI Console, open your instance details.
2. Click on the **Subnet** link under **Primary VNIC information**.
3. Click on the **Default Security List for `<your-vcn>`**.
4. Click **Add Ingress Rules**:
   - **Source CIDR**: `0.0.0.0/0`
   - **IP Protocol**: `TCP`
   - **Destination Port Range**: `80,443`
   - **Description**: `Allow HTTP and HTTPS traffic for n8n & Caddy`
5. Click **Add Ingress Rules**.

---

## Step 3: Get a Free Domain (2 Easy Options)

Caddy requires a domain name to automatically issue a valid Let's Encrypt SSL certificate. You can use either of these **100% free** methods:

### Option A: `sslip.io` (Instant — Zero Signup Needed ⚡)
`sslip.io` maps any IP address to a working domain automatically without creating an account or changing any DNS settings.
- Simply append `.sslip.io` to your Oracle Cloud Public IP:
  ```
  <YOUR_ORACLE_PUBLIC_IP>.sslip.io
  ```
- *Example*: If your Oracle VM IP is `140.238.150.80`, your domain is:
  ```
  140.238.150.80.sslip.io
  ```

### Option B: `DuckDNS.org` (Free Custom Subdomain 🦆)
1. Go to [https://www.duckdns.org/](https://www.duckdns.org/) and log in with your GitHub or Google account.
2. Under **Domains**, type a subdomain name (e.g. `shivam-n8n`) and click **add domain**.
3. In the **current ip** box, enter your **Oracle Cloud Public IP** and click **update ip**.
4. Your free domain will be:
   ```
   shivam-n8n.duckdns.org
   ```

---

## Step 4: Transfer Files to Your Oracle VM

### Option A: Using Git (Recommended)
Push your local n8n project to a private GitHub/GitLab repository, then on the server:
```bash
git clone <YOUR_GIT_REPO_URL> n8n
cd n8n
```

### Option B: Using SCP from Windows PowerShell
From your local machine in `d:\Project.ai2\n8n`:
```powershell
scp -i "C:\path\to\your\ssh_key" -r d:\Project.ai2\n8n ubuntu@<YOUR_ORACLE_PUBLIC_IP>:~/n8n
```

---

## Step 5: Run Automated Deployment on Oracle VM

1. Connect to your instance via SSH:
   ```powershell
   ssh -i "C:\path\to\your\ssh_key" ubuntu@<YOUR_ORACLE_PUBLIC_IP>
   ```

2. Navigate to the project directory:
   ```bash
   cd ~/n8n
   ```

3. Create and edit your production `.env` file:
   ```bash
   cp .env.prod.example .env
   nano .env
   ```
   Set:
   - `DOMAIN_NAME`: e.g. `n8n.yourdomain.com`
   - `SSL_EMAIL`: your real email address

4. Run the automated deployment script:
   ```bash
   sudo bash deploy_oracle.sh
   ```

The script will automatically:
- Configure the OS-level firewall (`iptables` / `ufw`) for ports 80 and 443.
- Install Docker and the Docker Compose plugin.
- Start **Caddy** and **n8n**.
- Obtain a valid Let's Encrypt SSL certificate.

---

## Step 6: Access Your Live n8n Instance

Open your browser and navigate to:
```
https://n8n.yourdomain.com
```

Create your owner account and start building cloud automations!

---

## Migrating Workflows from Local n8n to Cloud

### Exporting Local Workflows
In your local n8n web interface (`http://localhost:5678`):
1. Open the workflow you want to export.
2. Click the **Workflow menu** (three dots in the top right) > **Export Workflow** (JSON).

### Importing into Cloud n8n
In your live Cloud n8n web interface:
1. Click **Add Workflow** > Click the three dots menu > **Import from File**.
2. Select your downloaded JSON workflow.
3. Add any required API credentials under **Credentials**.
