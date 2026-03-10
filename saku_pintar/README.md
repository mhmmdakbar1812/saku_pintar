# saku_pintar

A new Flutter project.


finnhub API : d6e6obpr01qh94m30ligd6e6obpr01qh94m30lj0 

{
  "nodes": [
    {
      "parameters": {
        "method": "GET",
        "url": "https://script.google.com/macros/s/AKfycbzR-WLjuG-9D4PNXNYjyDyO1NGEqgDLC2kwxXjmgTLrShmAlU72YCbmrICRsf5N1A8/exec",
        "authentication": "none",
        "sendQuery": true,
        "queryParameters": {
          "parameters": [
            {
              "name": "symbol",
              "value": "={dummy}"
            }
          ]
        },
        "placeholderDefinitions": {
          "values": [
            {
              "name": "dummy",
              "description": "Kode saham IHSG yang dicari (contoh: BBCA, GOTO, BMRI)"
            }
          ]
        },
        "name": "CekSahamIHSG",
        "description": "Gunakan tool ini khusus untuk mengecek harga saham Indonesia (IHSG) secara real-time. Kamu wajib memasukkan kode saham 4 huruf ke dalam parameter."
      },
      "name": "API Saham Pribadi",
      "type": "@n8n/n8n-nodes-langchain.toolHttpRequest",
      "typeVersion": 1.1,
      "position": [
        800,
        600
      ]
    }
  ],
  "connections": {}
}