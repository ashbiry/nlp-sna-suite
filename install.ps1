Write-Host "================================================"
Write-Host "        NLP + SNA Lab"
Write-Host "        Lab File Downloader"
Write-Host "================================================"
Write-Host ""

# Base URL of the GitHub repo (raw content)
$repoBase = "https://raw.githubusercontent.com/ashbiry/nlp-sna-suite/main"
if ($env:NLPSNA_REPO_BASE) { $repoBase = $env:NLPSNA_REPO_BASE }

# Progress bar makes Invoke-WebRequest very slow on Windows PowerShell 5.1
$ProgressPreference = 'SilentlyContinue'

# Practicals: id, repo folder, description, files (downloaded into ./<folder with / replaced by ->/)
$practicals = @(
    @{ id = "s1"; folder = "sna/1"; desc = "SNA 1: Coding Social Networks (igraph, ggraph)";
       files = @("exp1.ipynb", "NOTES.md", "sample-output.txt", "plot-c-network-3plus.png", "plot-d-senators.png") },

    @{ id = "s2"; folder = "sna/2"; desc = "SNA 2: Working with APIs (senator tweets)";
       files = @("exp2.ipynb", "NOTES.md", "sample-output.txt") },

    @{ id = "s3"; folder = "sna/3"; desc = "SNA 3: Modeling a Network (box plot, scatter, regression)";
       files = @("exp3.ipynb", "NOTES.md", "sample-output.txt", "plot-a-boxplot.png", "plot-b-scatter.png") },

    @{ id = "s4"; folder = "sna/4"; desc = "SNA 4: Introduction to Text Analysis (mentions)";
       files = @("exp4.ipynb", "NOTES.md", "sample-output.txt") },

    @{ id = "s5"; folder = "sna/5"; desc = "SNA 5: Tools for Social Network Analysis (theory)";
       files = @("NOTES.md") },

    @{ id = "n1"; folder = "nlp/1"; desc = "NLP 1: Text Preprocessing & Frequent Terms (AG News)";
       files = @("exp1.ipynb", "NOTES.md") },

    @{ id = "n2"; folder = "nlp/2"; desc = "NLP 2: Bag of Words Review Classification (IMDb)";
       files = @("exp2.ipynb", "NOTES.md") },

    @{ id = "n3"; folder = "nlp/3"; desc = "NLP 3: TF-IDF Tweet Sentiment Analysis (Sentiment140)";
       files = @("exp3.ipynb", "NOTES.md") },

    @{ id = "n4"; folder = "nlp/4"; desc = "NLP 4: Named Entity Recognition (spaCy)";
       files = @("exp4.ipynb", "NOTES.md") },

    @{ id = "n5"; folder = "nlp/5"; desc = "NLP 5: Topic Modelling with LDA (20 Newsgroups)";
       files = @("exp5.ipynb", "NOTES.md") },

    @{ id = "n6"; folder = "nlp/6"; desc = "NLP 6: Text Generation with RNN, LSTM, GRU (GPU)";
       files = @("exp6.ipynb", "NOTES.md") },

    @{ id = "n7"; folder = "nlp/7"; desc = "NLP 7: Transformer Summarization + ROUGE (GPU)";
       files = @("exp7.ipynb", "NOTES.md") }
)

# Resource files (downloaded keeping their folder, e.g. .\data\congress.RData)
$resources = @(
    @{ id = "d"; desc = "SNA datasets (.RData)";
       names = @("data/congress.RData", "data/committees.RData", "data/senator_tweets.RData", "data/senator_wiki.RData") },
    @{ id = "99"; desc = "Google Colab Setup Guide"; names = @("SETUP.md") }
)

$script:failed = $false

function Get-File($url, $outPath, $label) {
    $dir = Split-Path $outPath -Parent
    if ($dir -and -not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    try {
        Invoke-WebRequest -Uri $url -OutFile $outPath -UseBasicParsing -ErrorAction Stop
        Write-Host "  ✅ $label"
    } catch {
        Write-Host "  ❌ Failed: $label"
        $script:failed = $true
    }
}

function Get-Practical($p) {
    $outDir = $p.folder -replace '/', '-'
    Write-Host "`nDownloading $outDir ($($p.desc))..."
    foreach ($file in $p.files) {
        Get-File "$repoBase/$($p.folder)/$file" (Join-Path $outDir $file) "$outDir/$file"
    }
}

function Get-Resource($r) {
    Write-Host "`nDownloading $($r.desc)..."
    foreach ($name in $r.names) {
        Get-File "$repoBase/$name" $name $name
    }
}

function Complete-Run($message, $next) {
    if ($script:failed) {
        Write-Host "`n⚠️  Some files failed to download. Check your internet / the repository link."
    } else {
        Write-Host "`n✅ $message"
        if ($next) { Write-Host "`n$next" }
    }
    Write-Host "`nDone!"
}

# Display menu
Write-Host "Available Practicals:"
Write-Host "---------------------"
foreach ($p in $practicals) {
    Write-Host "  $($p.id). $($p.desc)"
    Write-Host "     [$($p.folder -replace '/', '-')] $($p.files -join ', ')"
}

Write-Host ""
Write-Host "Resource Files:"
Write-Host "---------------"
foreach ($r in $resources) {
    Write-Host "  $($r.id). $($r.desc)  [$($r.names -join ', ')]"
}

Write-Host ""
Write-Host "   0. Download everything (all practicals + resources)"

$allIds = @($practicals | ForEach-Object { $_.id }) + @($resources | ForEach-Object { $_.id }) + @("0")
$validIds = $allIds -join ", "
Write-Host ""
$choice = "$(Read-Host "Enter your choice [$validIds]")".Trim().ToLower()

if ($choice -eq "0") {
    foreach ($p in $practicals) { Get-Practical $p }
    foreach ($r in $resources)  { Get-Resource $r }
    Complete-Run "Everything downloaded to $((Get-Location).Path)\" $null
    return
}

$selectedResource = $resources | Where-Object { $_.id -eq $choice }
if ($selectedResource) {
    Get-Resource $selectedResource
    Complete-Run "Saved in $((Get-Location).Path)\" $null
    return
}

$selected = $practicals | Where-Object { $_.id -eq $choice }
if (-not $selected) {
    Write-Host "Invalid choice! Please enter one of: $validIds"
    return
}

Get-Practical $selected
$dirName = $selected.folder -replace '/', '-'
Complete-Run "All files downloaded to .\$dirName\" "Next: open the .ipynb in Google Colab (File -> Upload notebook) and read NOTES.md"
