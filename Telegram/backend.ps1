# ==========================================
# CONFIGURACIÓN
# ==========================================

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://127.0.0.1:8080/")


# ==========================================
# TELEGRAM
# ==========================================

$telegramToken = ""

# Chat ID de la cuenta de Telegram que recibirá los mensajes
$telegramChatId = ""


# ==========================================
# HISTORIAL
# ==========================================

$script:messages = @()

# Último update procesado de Telegram
$script:lastUpdateId = 0


# ==========================================
# FUNCIÓN: ENVIAR MENSAJE A TELEGRAM
# ==========================================

function Send-TelegramMessage {

    param (
        [string]$text
    )

    $url = "https://api.telegram.org/bot$telegramToken/sendMessage"

    $body = @{
        chat_id = $telegramChatId
        text    = $text
    } | ConvertTo-Json

    try {

        Invoke-RestMethod `
            -Uri $url `
            -Method Post `
            -ContentType "application/json" `
            -Body $body `
            -TimeoutSec 10 | Out-Null

        Write-Host "TELEGRAM: mensaje enviado"

        return $true
    }
    catch {

        Write-Host "ERROR ENVIANDO A TELEGRAM:"
        Write-Host $_.Exception.Message

        return $false
    }
}


# ==========================================
# FUNCIÓN: RECIBIR MENSAJES DE TELEGRAM
# ==========================================

function Receive-TelegramMessages {

    $offset = $script:lastUpdateId + 1

    $url = "https://api.telegram.org/bot$telegramToken/getUpdates?offset=$offset&timeout=1"

    try {

        $response = Invoke-RestMethod `
            -Uri $url `
            -Method Get `
            -TimeoutSec 5


        foreach ($update in $response.result) {

            # ----------------------------------
            # Actualizar último update
            # ----------------------------------

            if ($update.update_id -gt $script:lastUpdateId) {

                $script:lastUpdateId = $update.update_id
            }


            # ----------------------------------
            # Comprobar que sea un mensaje
            # ----------------------------------

            if ($null -eq $update.message) {
                continue
            }

            if ($null -eq $update.message.text) {
                continue
            }


            # ----------------------------------
            # Obtener datos
            # ----------------------------------

            $chatId = [string]$update.message.chat.id
            $text   = [string]$update.message.text


            # ----------------------------------
            # SOLO ACEPTAR MENSAJES DEL CHAT CONFIGURADO
            # ----------------------------------

            if ($chatId -eq [string]$telegramChatId) {

                $newMessage = [PSCustomObject]@{
                    sender = "misa"
                    text   = $text
                    time   = (Get-Date).ToString("HH:mm")
                }


                # IMPORTANTE:
                # Usamos $script: para modificar
                # el historial global.

                $script:messages += $newMessage

                Write-Host "TELEGRAM -> WEB: $text"
            }

            else {

                Write-Host "TELEGRAM IGNORADO - Chat ID: $chatId"
            }
        }
    }

    catch {

        Write-Host "ERROR RECIBIENDO TELEGRAM:"
        Write-Host $_.Exception.Message
    }
}


# ==========================================
# INICIAR SERVIDOR
# ==========================================

try {

    $listener.Start()
}

catch {

    Write-Host ""
    Write-Host "ERROR INICIANDO SERVIDOR"
    Write-Host $_.Exception.Message

    Read-Host "Presiona ENTER para cerrar"

    exit
}


Write-Host ""
Write-Host "=========================================="
Write-Host "        SERVIDOR DE MENSAJES OK"
Write-Host "=========================================="
Write-Host ""

Write-Host "Web:"
Write-Host "http://127.0.0.1:8080/"

Write-Host ""

Write-Host "Chat ID configurado:"
Write-Host $telegramChatId

Write-Host ""

Write-Host "=========================================="
Write-Host ""


# ==========================================
# SERVIDOR PRINCIPAL
# ==========================================

while ($true) {

    try {

        Write-Host "Esperando navegador..."

        $context = $listener.GetContext()

        Write-Host "NAVEGADOR CONECTADO"


        $path   = $context.Request.Url.AbsolutePath
        $method = $context.Request.HttpMethod


        # ======================================
        # PÁGINA PRINCIPAL
        # ======================================

        if ($path -eq "/") {

            $file = Join-Path $PSScriptRoot "frontend\index.html"


            if (Test-Path $file) {

                $html = Get-Content `
                    $file `
                    -Raw `
                    -Encoding UTF8

                $bytes = [System.Text.Encoding]::UTF8.GetBytes($html)

                $context.Response.StatusCode = 200
                $context.Response.ContentType = "text/html; charset=utf-8"
                $context.Response.ContentLength64 = $bytes.Length

                $context.Response.OutputStream.Write(
                    $bytes,
                    0,
                    $bytes.Length
                )
            }

            else {

                $html = "<h1>No se encontró index.html</h1>"

                $bytes = [System.Text.Encoding]::UTF8.GetBytes($html)

                $context.Response.StatusCode = 404
                $context.Response.ContentType = "text/html; charset=utf-8"
                $context.Response.ContentLength64 = $bytes.Length

                $context.Response.OutputStream.Write(
                    $bytes,
                    0,
                    $bytes.Length
                )
            }
        }


        # ======================================
        # OBTENER MENSAJES
        # ======================================

        elseif ($path -eq "/messages") {

            Write-Host "Consultando Telegram..."


            # Revisar si hay nuevos mensajes de Telegram

            Receive-TelegramMessages


            # ----------------------------------
            # Crear JSON
            # ----------------------------------

            $json = ConvertTo-Json `
                -InputObject @($script:messages) `
                -Depth 5


            $bytes = [System.Text.Encoding]::UTF8.GetBytes($json)

            $context.Response.StatusCode = 200
            $context.Response.ContentType = "application/json; charset=utf-8"
            $context.Response.ContentLength64 = $bytes.Length

            $context.Response.OutputStream.Write(
                $bytes,
                0,
                $bytes.Length
            )


            Write-Host "MENSAJES ENVIADOS A WEB: $($script:messages.Count)"
        }


        # ======================================
        # ENVIAR MENSAJE DESDE LA WEB
        # ======================================

        elseif ($path -eq "/send" -and $method -eq "POST") {

            $reader = New-Object System.IO.StreamReader(
                $context.Request.InputStream,
                $context.Request.ContentEncoding
            )


            $body = $reader.ReadToEnd()

            $reader.Close()


            Write-Host ""
            Write-Host "MENSAJE RECIBIDO DESDE WEB:"
            Write-Host $body


            try {

                $data = $body | ConvertFrom-Json

                $message = [string]$data.message


                if (
                    $message -and
                    $message.Trim().Length -gt 0
                ) {

                    $message = $message.Trim()


                    # ----------------------------------
                    # Enviar a Telegram
                    # ----------------------------------

                    $sent = Send-TelegramMessage $message


                    if ($sent) {

                        # ----------------------------------
                        # Guardar mensaje como MAMÁ
                        # ----------------------------------

                        $newMessage = [PSCustomObject]@{
                            sender = "mama"
                            text   = $message
                            time   = (Get-Date).ToString("HH:mm")
                        }


                        $script:messages += $newMessage


                        Write-Host "MENSAJE GUARDADO"
                        Write-Host "WEB -> TELEGRAM"


                        $responseData = @{
                            ok = $true
                        }
                    }

                    else {

                        $responseData = @{
                            ok    = $false
                            error = "No se pudo enviar a Telegram"
                        }
                    }
                }

                else {

                    $responseData = @{
                        ok    = $false
                        error = "Mensaje vacío"
                    }
                }
            }

            catch {

                Write-Host "ERROR PROCESANDO JSON:"
                Write-Host $_.Exception.Message


                $responseData = @{
                    ok    = $false
                    error = "JSON inválido"
                }
            }


            # ----------------------------------
            # Responder al navegador
            # ----------------------------------

            $json = $responseData | ConvertTo-Json

            $bytes = [System.Text.Encoding]::UTF8.GetBytes($json)

            $context.Response.StatusCode = 200
            $context.Response.ContentType = "application/json; charset=utf-8"
            $context.Response.ContentLength64 = $bytes.Length

            $context.Response.OutputStream.Write(
                $bytes,
                0,
                $bytes.Length
            )
        }


        # ======================================
        # 404
        # ======================================

        else {

            $html = "<h1>404 - No encontrado</h1>"

            $bytes = [System.Text.Encoding]::UTF8.GetBytes($html)

            $context.Response.StatusCode = 404
            $context.Response.ContentType = "text/html; charset=utf-8"
            $context.Response.ContentLength64 = $bytes.Length

            $context.Response.OutputStream.Write(
                $bytes,
                0,
                $bytes.Length
            )
        }


        # ======================================
        # CERRAR RESPUESTA
        # ======================================

        $context.Response.OutputStream.Close()

        Write-Host "RESPUESTA ENVIADA: $path"
        Write-Host ""

    }

    catch {

        Write-Host ""
        Write-Host "ERROR EN SERVIDOR:"
        Write-Host $_.Exception.Message
        Write-Host ""
    }
}
```

### Para configurarlo

Solo tiene que completar estas dos líneas:

$telegramToken = "T
