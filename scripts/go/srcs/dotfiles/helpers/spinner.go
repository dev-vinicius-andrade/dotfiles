package helpers

import (
	"fmt"
	"github.com/fatih/color"
	"os"
	"os/signal"
	"sync"
	"syscall"
	"time"
)

var defaultChars = []string{"⠁", "⠁", "⠉", "⠙", "⠚", "⠒", "⠂", "⠂", "⠒", "⠲", "⠴", "⠤", "⠄", "⠄", "⠤", "⠠", "⠠", "⠤", "⠦", "⠖", "⠒", "⠐", "⠐", "⠒", "⠓", "⠋", "⠉", "⠈", "⠈"}

type colors struct {
	Spinner      *color.Color
	Text         *color.Color
	Progress     *color.Color
	FinishedIcon *color.Color
	ErrorIcon    *color.Color
	ErrorText    *color.Color
}
type icons struct {
	Finished  string
	Error     string
	Cancelled string
}
type Spinner struct {
	chars       []string
	current     int
	totalSteps  int
	currentStep int
	message     string
	finishedMsg string
	colors      *colors
	lock        sync.Mutex
	done        chan bool
	active      bool
	icons       *icons
}

var spinner *Spinner

func NewSpinner() *Spinner {
	return &Spinner{
		chars:       defaultChars,
		current:     0,
		finishedMsg: "Done!",
		done:        make(chan bool),
		colors: &colors{
			Spinner:      color.New(color.FgGreen, color.Bold),
			Text:         color.New(color.FgHiWhite),
			Progress:     color.New(color.FgCyan, color.Bold),
			ErrorIcon:    color.New(color.FgRed, color.Bold),
			FinishedIcon: color.New(color.FgGreen, color.Bold),
			ErrorText:    color.New(color.FgRed, color.Bold, color.Italic),
		},
		icons: &icons{
			Finished:  "✓",
			Error:     "✗",
			Cancelled: "⚠️",
		},
	}
}
func (s *Spinner) SetErrorIcon(icon string) *Spinner {
	s.lock.Lock()
	defer s.lock.Unlock()
	s.icons.Error = icon
	return s
}
func (s *Spinner) SetFinishedIcon(icon string) *Spinner {
	s.lock.Lock()
	defer s.lock.Unlock()
	s.icons.Finished = icon
	return s
}
func (s *Spinner) SetFinishedIconColor(color *color.Color) *Spinner {
	s.lock.Lock()
	defer s.lock.Unlock()
	s.colors.FinishedIcon = color
	return s
}
func (s *Spinner) SetErrorIconColor(color *color.Color) *Spinner {
	s.lock.Lock()
	defer s.lock.Unlock()
	s.colors.ErrorIcon = color
	return s

}
func (s *Spinner) SetSpinnerColor(color *color.Color) *Spinner {
	s.lock.Lock()
	defer s.lock.Unlock()
	s.colors.Spinner = color
	return s
}

func (s *Spinner) SetTextColor(color *color.Color) *Spinner {
	s.lock.Lock()
	defer s.lock.Unlock()
	s.colors.Text = color
	return s
}
func (s *Spinner) SetErrorTextColor(color *color.Color) *Spinner {
	s.lock.Lock()
	defer s.lock.Unlock()
	s.colors.ErrorText = color
	return s
}
func (s *Spinner) SetProgressColor(color *color.Color) *Spinner {
	s.lock.Lock()
	defer s.lock.Unlock()
	s.colors.Progress = color
	return s
}
func (s *Spinner) GetDefaultChars(chars []string) []string {
	return defaultChars
}
func (s *Spinner) OverrideDefaultChars(chars []string) *Spinner {
	s.lock.Lock()
	defer s.lock.Unlock()
	s.chars = chars
	return s
}

func (s *Spinner) Start() *Spinner {
	s.active = true
	s.setupCloseHandler()
	go func() {
		for {
			select {
			case <-s.done:
				return
			default:
				s.lock.Lock()
				s.print()
				s.lock.Unlock()
				time.Sleep(100 * time.Millisecond)
				s.current = (s.current + 1) % len(s.chars)
			}
		}
	}()
	return s
}
func (s *Spinner) Reset() *Spinner {
	s.lock.Lock()
	defer s.lock.Unlock()
	s.active = false
	s.current = 0
	s.done = make(chan bool)
	s.message = ""
	s.totalSteps = 0
	s.currentStep = 0
	return s
}
func clearLine() {
	fmt.Print("\r\033[2K")

}
func (s *Spinner) print() *Spinner {
	clearLine()
	template := "\r"
	template += fmt.Sprintf("%s%s%s ", s.colors.Text.Sprintf("["), s.colors.Spinner.Sprintf("%s", s.chars[s.current]), s.colors.Text.Sprintf("]"))
	color.Unset()
	template += s.colors.Text.Sprintf("%s", s.message)
	color.Unset()
	if s.totalSteps > 0 {
		template += s.colors.Progress.Sprintf("	[ %d of %d ] ", s.currentStep, s.totalSteps)
	}
	fmt.Print(template)
	color.Unset()
	return s
}

func (s *Spinner) Finish() {
	clearLine()
	icon := s.colors.FinishedIcon.Sprintf(s.icons.Finished)
	message := s.colors.Text.Sprintf(s.finishedMsg)
	fmt.Printf("\r %s - %s\n", icon, message)
	color.Unset()
	s.Reset()
}

func (s *Spinner) SetMessage(message string) *Spinner {
	s.lock.Lock()
	defer s.lock.Unlock()
	s.message = message
	return s
}
func (s *Spinner) SetFatalError(err error) {
	clearLine()
	icon := s.colors.ErrorIcon.Sprintf(s.icons.Error)
	message := s.colors.ErrorText.Sprintf(" !!- %s", err)
	fmt.Printf("\r %s - %s\n", icon, message)
	color.Unset()
	s.Reset()
	os.Exit(1)
}
func (s *Spinner) SetError(err error) {
	clearLine()
	icon := s.colors.ErrorIcon.Sprintf(s.icons.Error)
	message := s.colors.ErrorText.Sprintf(" !!- %s", err)
	fmt.Printf("\r %s - %s\n", icon, message)
	color.Unset()
	s.Reset()

}

func (s *Spinner) SetTotalSteps(total int) *Spinner {
	s.lock.Lock()
	defer s.lock.Unlock()
	s.totalSteps = total
	return s
}

func (s *Spinner) NextStep() {
	s.lock.Lock()
	defer s.lock.Unlock()
	if s.currentStep < s.totalSteps-1 {
		s.currentStep++
	}
}

func (s *Spinner) setupCloseHandler() {
	c := make(chan os.Signal)
	signal.Notify(c, os.Interrupt, syscall.SIGTERM)
	go func() {
		<-c
		clearLine()

		message := s.colors.Text.Sprintf("%s !!- Process interrupted and stopped.", s.icons.Cancelled)
		fmt.Println(message)
		os.Exit(0)
	}()
}
func (s *Spinner) SetFinishedMessage(message string) *Spinner {
	s.finishedMsg = message
	return s
}
