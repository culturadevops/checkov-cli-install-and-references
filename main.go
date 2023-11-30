package main

//checkov --disable-inline-skips
import (
	"flag"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"regexp"
	"strings"
)

func check(err error) {
	if err != nil {
		log.Fatal(err)
	}
}
func isFileFormatAllowed(filePath string, allowedFormats []string) bool {
	ext := filepath.Ext(filePath)
	for _, format := range allowedFormats {
		if strings.ToLower(ext) == strings.ToLower(format) {
			return true
		}
	}
	return false
}
func isFileAllow(filePath string, fileAllow []string) bool {
	for _, filePathAllow := range fileAllow {
		fileName := filepath.Base(filePath)
		isAcept := strings.EqualFold(fileName, filePathAllow)
		if isAcept {
			return true
		}
	}
	return false

}

func searchPatternInFile(filePath string, pattern string, allowedFormats, allowedFileName []string) bool {
	//fmt.Printf("El archivo %s:\n", filePath)
	if !isFileAllow(filePath, allowedFileName) {
		if !isFileFormatAllowed(filePath, allowedFormats) {
			//fmt.Printf("Formato de archivo no permitido: %s\n", filePath)
			return false
		}
	}
	fmt.Printf("El archivo analizados %s:\n", filePath)
	fileContent, err := os.ReadFile(filePath)
	check(err)

	re := regexp.MustCompile(pattern)
	matches := re.FindAllStringIndex(string(fileContent), -1)

	if len(matches) > 0 {
		fmt.Printf("Encontrado patrón en el archivo: %s\n", filePath)
		for _, match := range matches {
			lineNumber := 1 + bytesToLineNumber(fileContent, match[0])
			fmt.Printf("   - Patrón encontrado en la línea %d\n", lineNumber)
		}
		return true
	}
	return false
}

func bytesToLineNumber(content []byte, index int) int {
	lineNumber := 1
	for i, b := range content {
		if i >= index {
			break
		}
		if b == '\n' {
			lineNumber++
		}
	}
	return lineNumber
}

func searchPatternInDirectory(dirPath string, pattern string, allowedFormats, allowedFileName []string) {
	found := false
	err := filepath.Walk(dirPath, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if !info.IsDir() {
			if searchPatternInFile(path, pattern, allowedFormats, allowedFileName) {
				found = true
			}
		}
		return nil
	})
	check(err)

	if found {
		os.Stderr.Write([]byte("Se encontró el patrón en al menos un archivo."))
		//fmt.Println("No se encontró el patrón en ningún archivo.")
		os.Exit(1) // Código de salida 2 indica fallo

	} else {
		fmt.Println("No se encontró el patrón en ningún archivo.")
		os.Exit(0) // Código de salida 0 indica éxito
	}
}

func main() {
	var (
		nombre string
	)

	// Definir las variables que deseas capturar como argumentos
	flag.StringVar(&nombre, "dir", "", "direccion a analizar")
	flag.Parse()
	fmt.Println(nombre)
	directoryPath := nombre                       // Cambiar por la ruta del directorio que deseas buscar
	pattern := "#checkov:skip=.*"                 // Cambiar por el patrón que estás buscando
	allowedFileFormats := []string{".yml", ".tf"} // Cambiar o agregar extensiones permitidas
	allowedFileName := []string{"Dockerfile"}     // Cambiar o agregar extensiones permitidas

	searchPatternInDirectory(directoryPath, pattern, allowedFileFormats, allowedFileName)
}
