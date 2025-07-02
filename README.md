# Six Sigma Analytics Dashboard

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    Customer Data Sources                         │
├─────────────────┬─────────────────┬─────────────────────────────┤
│   Shopify API   │  WooCommerce    │    CSV/Excel Upload         │
│   BigCommerce   │  Custom APIs    │    Manual Entry             │
└─────────────────┴─────────────────┴─────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                    API Gateway Layer                            │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │              Google OAuth 2.0                          │   │
│  │            Authentication & JWT                         │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                  Serverless Processing Layer                    │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  Analytics Functions (Cloud Functions)                  │   │
│  │  ├── DMAIC Processor                                   │   │
│  │  ├── SPC Calculator (Cp, Cpk, Pp, Ppk)               │   │
│  │  ├── DPMO Calculator                                  │   │
│  │  ├── Sigma Level Engine                               │   │
│  │  └── Pareto Analysis                                  │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                     Data Storage Layer                          │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │              Cloud Firestore                           │   │
│  │  ├── Process Data Collections                         │   │
│  │  ├── Historical Metrics                               │   │
│  │  ├── User Configurations                              │   │
│  │  └── DMAIC Project Tracking                           │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Frontend Dashboard                           │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │              React TypeScript SPA                      │   │
│  │  ├── Control Charts (X-bar, R, p, np)                │   │
│  │  ├── Process Capability Dashboard                     │   │
│  │  ├── DMAIC Project Manager                            │   │
│  │  ├── Real-time Sigma Level Monitor                    │   │
│  │  └── Defect Analysis & Pareto Charts                  │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│              Hosted on Cloud Storage + CDN                     │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                      End Users                                  │
│  ┌─────────────────┬─────────────────┬─────────────────────┐   │
│  │  Quality Mgrs   │  Process Engrs  │  Business Analysts  │   │
│  │  Operations     │  Six Sigma      │  Executive          │   │
│  │  Teams          │  Black Belts    │  Dashboard          │   │
│  └─────────────────┴─────────────────┴─────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

## Project Overview

A serverless Six Sigma analytics dashboard for ecommerce businesses built on Google Cloud Platform. This application provides real-time quality metrics, statistical process control, and DMAIC methodology tracking to help optimize business processes and reduce defects.

### Goals of this project:
 - Implement Six Sigma methodology in ecommerce analytics
 - Use serverless GCP architecture for scalable analytics processing
 - Provide real-time quality metrics and control charts
 - Enable data-driven process improvement decisions
 - Cost-effective infrastructure for small to medium businesses
 - Infrastructure as Code (IaaC) approach
 - Implement CI/CD for continuous deployment

## Key Features

### Six Sigma Analytics
- **Statistical Process Control (SPC)** - X-bar, R, p, np control charts
- **Process Capability Analysis** - Cp, Cpk, Pp, Ppk calculations
- **DMAIC Tracking** - Define, Measure, Analyze, Improve, Control phases
- **Defect Analysis** - DPMO (Defects Per Million Opportunities)
- **Sigma Level Calculator** - Real-time process sigma level monitoring
- **Pareto Analysis** - Root cause identification and prioritization

### Ecommerce Metrics
- Order fulfillment time variations
- Product return rate analysis
- Customer satisfaction distribution
- Shipping accuracy tracking
- Inventory turnover consistency
- Process performance dashboards

## Architecture

### Serverless Infrastructure
![Six Sigma Analytics Architecture](https://user-images.githubusercontent.com/7352031/229307386-f89c6989-bcb7-4a27-be64-ed85af6e6e84.png)

**Components:**
- **Frontend:** React TypeScript with Material-UI for analytics dashboards
- **Backend:** Node.js Cloud Functions for data processing and Six Sigma calculations
- **Database:** Firestore for storing process data and historical metrics
- **API Gateway:** Routes requests and handles authentication
- **Cloud Storage:** Static asset hosting and data export storage
- **Authentication:** Google OAuth 2.0 integration

### Benefits of this Architecture:
 - **Cost-effective:** Free tier covers ~2M API calls per month
 - **Highly scalable:** Auto-scaling serverless functions
 - **No server management:** Focus on analytics, not infrastructure
 - **Real-time processing:** Cloud Functions for immediate metric calculations
 - **Secure:** Google OAuth with JWT token authentication
 - **Fast deployment:** Infrastructure provisioned in minutes
 - **Open technology stack:** Node.js, React, Terraform, GitHub Actions

## Prerequisites 

### Required Tools
 - [Node.js](https://nodejs.org/) (>= 18.0.0)
 - [Terraform](https://www.terraform.io/downloads.html) (for infrastructure)
 - [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) (optional)

### GCP Setup
Enable the following APIs in your GCP project:
 - Cloud Functions API
 - Cloud Firestore API
 - API Gateway API
 - Cloud Storage API
 - IAM Service Account Credentials API
 - Secret Manager API

### Service Accounts
Create service accounts for:
 - GitHub Actions (CI/CD)
 - Local development
 - Production deployment

## Quick Start

### 1. Clone and Setup
```bash
git clone <repository-url>
cd six-sigma-analytics-dashboard
```

### 2. Frontend Development
```bash
cd frontend/client-app
npm install
npm start
```
Dashboard will be available at http://localhost:3000

### 3. Backend Development
```bash
cd backend/service-analytics
npm install
npm run dev
```
API will be available at http://localhost:8080

### 4. Infrastructure Deployment
```bash
cd infra
terraform init
terraform plan
terraform apply
```

## Data Sources

The dashboard supports mock data generation for development and testing. In production, you can integrate with:
- **Ecommerce APIs:** Shopify, WooCommerce, BigCommerce
- **Analytics APIs:** Google Analytics, Adobe Analytics  
- **Business Systems:** ERP, CRM, Order Management Systems
- **Custom APIs:** Your existing business systems

## Six Sigma Methodology

### DMAIC Process Support
- **Define:** Problem definition and goal setting
- **Measure:** Data collection and baseline establishment
- **Analyze:** Root cause analysis and process mapping
- **Improve:** Solution implementation tracking
- **Control:** Ongoing monitoring and sustainability

### Key Metrics Calculated
- **Process Capability:** Cp, Cpk, Pp, Ppk
- **Sigma Level:** Real-time process sigma calculation
- **DPMO:** Defects Per Million Opportunities
- **Control Limits:** Statistical process control boundaries
- **Trend Analysis:** Process performance over time

## Development

### Project Structure
```
├── Sigma-frontend/client-app/           # React TypeScript Six Sigma Dashboard
│   ├── src/components/
│   │   ├── DMaicDashboard.tsx          # Main DMAIC analytics dashboard
│   │   ├── ProcessNavigation.tsx       # Six Sigma process navigation
│   │   ├── QualityMetricsBar.tsx       # Real-time quality metrics bar
│   │   └── SigmaLayout.tsx             # Main application layout
│   ├── src/hooks/
│   │   ├── useSigmaClient.ts           # Six Sigma API client hook
│   │   ├── useDebounce.ts              # Debounce utility hook
│   │   └── useFetch.ts                 # Data fetching hook
│   └── src/utils/
│       └── statisticalUtils.ts         # Statistical calculation utilities
├── Sigma-backend/                      # Serverless analytics processing
│   ├── dmaic-processor/                # DMAIC methodology processor
│   ├── spc-calculator/                 # Statistical process control
│   ├── sigma-level-engine/             # Sigma level calculations
│   └── defect-analyzer/                # Defect analysis service
├── infra/                              # Terraform GCP infrastructure
│   ├── main.tf                         # Main infrastructure configuration
│   ├── api.yaml                        # API Gateway specification
│   └── modules/function/               # Cloud Functions module
└── docs/                               # Six Sigma methodology documentation
```

### Contributing
1. Fork the repository
2. Create a feature branch
3. Make changes and test locally
4. Submit a pull request

## License
This project is licensed under the Apache 2.0 License.