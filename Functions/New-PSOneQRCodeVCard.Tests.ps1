BeforeAll {
    Import-Module "$PSScriptRoot\..\loader.psm1" -Force
    $Global:defaultQrCodePath | Remove-Item -Force -ErrorAction SilentlyContinue
}

Describe 'New-PSOneQRCodeVCard' {
    AfterEach {
        $Global:defaultQrCodePath | Remove-Item -Force -ErrorAction SilentlyContinue
    }

    It 'defaults to file based output and use mandatory input' {
        $splat = @{
            FirstName = 'Test'
            LastName  = 'Test'
        }
        New-PSOneQRCodeVCard @splat

        Get-Item $Global:defaultQrCodePath | Should -Exist
    }

    It 'defaults to file based output and use optional input' {
        $splat = @{
            FirstName = 'Test'
            LastName  = 'Test'
            Company   = 'Test'
            Title     = 'Mr'
            Email     = 'tst@test.test'
            Mobile    = '00123456789'
        }
        New-PSOneQRCodeVCard @splat

        Get-Item $Global:defaultQrCodePath | Should -Exist
    }

    It 'returns the byte array when `-AsByteArray` switch is on' {
        $splat = @{
            FirstName   = 'Test'
            LastName    = 'Test'
            Company     = 'Test'
            Email       = 'tst@test.test'
            AsByteArray = $True
        }
        $byteArray = New-PSOneQRCodeVCard @splat

        $byteArray.Count | Should -Not -BeNullOrEmpty
        Test-Path $Global:defaultQrCodePath | Should -BeFalse
    }
}

AfterAll {
    Remove-Module "$PSScriptRoot\..\loader.psm1" -Force -ErrorAction SilentlyContinue
}
